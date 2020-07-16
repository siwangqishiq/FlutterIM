import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imclient/env/ServerConfig.dart';
import 'package:imclient/im/Action.dart';
import 'package:imclient/im/AutoLogin.dart';
import 'package:imclient/im/GetFriendListAction.dart';
import 'package:imclient/im/LoginAction.dart';
import 'package:imclient/im/LoginOutAction.dart';
import 'package:imclient/model/Codec.dart';
import 'package:imclient/model/Friend.dart';
import 'package:imclient/model/bytebuf.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/model/Login.dart';
import 'package:imclient/core/Codes.dart';
import 'package:imclient/core/Account.dart';

//typedef OnMsgCallback = bool Function(Msg msg);

abstract class ClientCallback{
  //受到消息
  void onReceivedMsg(Msg msg);

  //网络状态改变
  void onNetStatusChange(NetStatus oldStatus , NetStatus newStatus);
}

abstract class AuthCallback{
  //验证登录成功
  void onAuthSuccess(String token , String account , int uid);

  //登录失败
  void onAuthError(int errorCode);
}

//注销登录回调
abstract class LoginOutCallback{
  void loginOutSuccess();

  void loginOutError();
}

enum NetStatus{
  offline, //初始 离线状态
  connecting, //连接中 
  online //在线
}

class IMClient{
  static IMClient instance;

  Socket _socket;
  NetStatus  _netStatus;

  List<ClientCallback> callbackList = [];
  AuthCallback _authCallback;
  LoginOutCallback _loginOutCallback;
  
  List<Msg> _waitSendMsgs = [];//缓存未来得及发送的数据包
  List<int> preRawData =[];//上一次未读取完的byte数据

  static IMClient getInstance(){
    if(instance == null){
      instance = new IMClient();
    }

    return instance;
  }

  IMClient(){
    _netStatus = NetStatus.offline;
    preRawData.clear();
  }

  void init(){
    connectServer();
  }

  void addAuthCallback(AuthCallback authCb){
    if(_authCallback != authCb){
      _authCallback = authCb;
    }
  }

  void addLoginOutCallback(LoginOutCallback cb){
    if(_loginOutCallback != cb){
        _loginOutCallback = cb;
    }
  }

  void clearLoginOutCallback(){
    _loginOutCallback = null;
  }

  //添加事件监听
  bool addListener(ClientCallback cb){
    if(callbackList.contains(cb)){
      return false;
    }

    callbackList.add(cb);
    return true;
  }

  //移除事件监听
  bool removeListener(ClientCallback cb){
    return callbackList.remove(cb);
  }

  void clearAuthCallback(){
    _authCallback = null;
  }

  void connectServer(){
    if(_netStatus == NetStatus.online || _netStatus == NetStatus.connecting){
      print("connect server cancel");
      return;
    }

    //print("im netclient init");
    _switchStatus(_netStatus, NetStatus.connecting);

    Socket.connect(ServerConfig.instance.imServer , ServerConfig.instance.imPort , timeout: Duration(milliseconds: 30*1000))
    .then((socket){
      print("connect success! ${socket.address} : ${socket.port} => ${socket.remoteAddress} : ${socket.remotePort}");
      _socket = socket;
      _switchStatus(_netStatus, NetStatus.online);

      addSocketListener();

      // 
      while(_waitSendMsgs.isNotEmpty){
        Msg msg = _waitSendMsgs.removeAt(0);
        sendMsg(msg);
      }
    })
    .catchError((e){
      _switchStatus(_netStatus, NetStatus.offline);
      
      if(_socket != null){
        _socket.close();
      }
      print("连接发生错误 connect error ${e.toString()}");
    });
  }

  void addSocketListener(){
    if(_socket == null)
      return;

    _socket.listen(
      (Uint8List data){
        print("received (${data.lengthInBytes}   |   ${data.length} ): ${data.runtimeType}");
        //print("content = ${ByteBufUtil.readString(data)}");

        List<Msg> msgList = _parseRawData(data);

        for(Msg msg in msgList){
          if(msg == null)
            continue;
        
          print("received msg : length = ${msg.length} code = ${msg.code} ");  
          //print("content = ${msg.data}");     
        
          _handleMsg(msg);
        }//end for each
      },
      onDone: (){
        print("on close socket");
        closeSocket();
      },
      onError: (e){
        print("onError : ${e.toString()}");
        _switchStatus(_netStatus, NetStatus.offline);
      },  
      cancelOnError: false,
    );
  }

  //解析接收到的原始数据
  List<Msg> _parseRawData(Uint8List rawData){
    List<int> dataList = ByteBufUtil.convertUint8ListToMutable(rawData);
    
    if(preRawData.isNotEmpty){ //拼接上一次的数据
      dataList.insertAll(0, preRawData);
      preRawData.clear();
    }

    List<Msg> resultMsgList = [];

    while(dataList.isNotEmpty){
      if(dataList.length < 4){ // 首字节不足4位
        preRawData.addAll(dataList);
        dataList.removeRange(0, dataList.length);
        break;
      }

      int len = ByteBufUtil.readInt32(dataList);
      if(len > dataList.length){//数据不完整
        preRawData.addAll(dataList);
        dataList.removeRange(0, dataList.length);
        break;
      }else{ // len <= data.length
        Msg msg = new Msg();
        print("msg len = $len  , dataLen = ${dataList.length}");
        msg.decode(Uint8List.fromList(dataList.sublist(0,len)));

        resultMsgList.add(msg);

        dataList.removeRange(0, len);
      }
    }//end while
    return resultMsgList;
  }

  void closeSocket(){
    _netStatus = NetStatus.offline;
  }

  // 发送Msg消息
  void sendMsg(Msg msg){
    if(_netStatus == NetStatus.online){
      // print("send msg : ${msg.code} ${msg.length} ${msg.data}");
      var sendBytes = msg.encode();
      //print("sendBytes : $sendBytes");
      //_socket.write(sendBytes);
      _socket.add(sendBytes);
      _socket.flush();
    }else if(_netStatus == NetStatus.connecting){
      _waitSendMsgs.add(msg);
    }else if(_netStatus == NetStatus.offline){
      _waitSendMsgs.add(msg);
      connectServer();
    }
  }

  void dispose(){
    print("im netclient dispose");
    if(_socket != null){
      _socket.close().then((r){
        print("close socket success");
        _socket = null;
        _switchStatus(_netStatus , NetStatus.offline);
      }).catchError((e){
        print("close socket error ${e.toString()}");
      });
    }
  }

  void _switchStatus(NetStatus oldStatus , NetStatus newStatus){
    print("oldStatus: $oldStatus  newStatus: $newStatus");
    if(_netStatus != newStatus){
      _netStatus = newStatus;
      
      //callback
      for(ClientCallback cb in callbackList){
        cb.onNetStatusChange(oldStatus, newStatus);
      }//end for each
    }
  }

  void _sendModel(Codec model){
    Msg msg = Msg.buildMsg(model.getCode() ,model);
    print("msg = ${msg.length}  ${msg.code}");
    sendMsg(msg);
  }

  //用户名密码手动登录
  void auth(String account , String password){
    LoginReq loginReq = new LoginReq();
    loginReq.account = account;
    loginReq.password = password;
    
    _sendModel(loginReq);
  }

  //注销登录
  void loginOut(){
    LoginOutReq loginOutReq = new LoginOutReq(Account.getUid());
    _sendModel(loginOutReq);
  }

  //利用token 自动登录
  void autoLogin(){
    AutoLoginReq autoLoginReq = new AutoLoginReq();
    _sendModel(autoLoginReq);
  }

  //处理消息
  void _handleMsg(Msg msg){
    IMAction action;
    switch(msg.code){
      case Codes.CODE_LOGIN_RESP://登录响应
        action = new LoginAction(_authCallback);
        break;
      case Codes.CODE_LOGIN_OUT_RESP://注销登录 响应
        action = new LoginOutAction(_loginOutCallback);
        break;
      case Codes.CODE_AUTO_LOGIN_RESP://自动登录
        action = new AutoLoginAction();
        break;
      case Codes.CODE_FRIEND_LIST_RESP://好友列表
        action = new GetFriendListAction();
        break;
    }//end switch

    //执行action 逻辑
    if(action == null)
      return;

    action.handleMsg(msg);

    if(action.needCallback()){
      for(ClientCallback callback in callbackList){ //callback for others
        callback.onReceivedMsg(msg);
      }//end for each
    }
  }

}//end class
