import 'dart:io';
import 'dart:typed_data';
import 'package:imclient/env/ServerConfig.dart';
import 'package:imclient/model/Codec.dart';
import 'package:imclient/model/bytebuf.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/model/Login.dart';

//typedef OnMsgCallback = bool Function(Msg msg);

abstract class ClientCallback{
  //受到消息
  void onReceivedMsg(Msg msg);

  //网络状态改变
  void onNetStatusChange(NetStatus oldStatus , NetStatus newStatus);
}

abstract class AuthCallback{
  void onAuthResult(int resultCode, String token);
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
  
  List<Msg> _waitSendMsgs = [];

  static IMClient getInstance(){
    if(instance == null){
      instance = new IMClient();
    }

    return instance;
  }

  IMClient(){
    _netStatus = NetStatus.offline;
  }

  void init(){
    connectServer();
  }

  void addAuthCallback(AuthCallback authCb){
    if(_authCallback != authCb){
      _authCallback = authCb;
    }
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
        Msg msg = ByteBufUtil.readMsg(data);

        if(msg == null)
          return;
        
        print("received msg : length = ${msg.length} code = ${msg.code} ");  
        //print("content = ${msg.data}");     
        
        _handleMsg(msg);

        for(ClientCallback callback in callbackList){
          callback.onReceivedMsg(msg);
        }
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

  void closeSocket(){
    _netStatus = NetStatus.offline;
  }

  void _handleMsg(Msg msg){
    
  }

  // 发送Msg消息
  void sendMsg(Msg msg){
    if(_netStatus == NetStatus.online){
      // print("send msg : ${msg.code} ${msg.length} ${msg.data}");
      var sendBytes = msg.encode();
      // print("sendBytes : $sendBytes");
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
    sendMsg(msg);
  }

  void auth(String account , String password){
    LoginReq loginReq = new LoginReq();
    loginReq.account = account;
    loginReq.password = password;
    
    _sendModel(loginReq);
  }
  
}//end class
