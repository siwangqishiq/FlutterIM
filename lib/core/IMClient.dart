import 'dart:io';
import 'dart:typed_data';
import 'package:imclient/env/ServerConfig.dart';
import 'package:imclient/model/bytebuf.dart';
import 'package:imclient/model/Msg.dart';

//typedef OnMsgCallback = bool Function(Msg msg);

abstract class MsgCallback{
  void onReceivedMsg(Msg msg);
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

  List<MsgCallback> callbackList = [];
  
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

  //添加事件监听
  bool addListener(MsgCallback cb){
    if(callbackList.contains(cb)){
      return false;
    }

    callbackList.add(cb);
    return true;
  }

  //移除事件监听
  bool removeListener(MsgCallback cb){
    return callbackList.remove(cb);
  }

  void connectServer(){
    if(_netStatus == NetStatus.online || _netStatus == NetStatus.connecting){
      print("connect server cancel");
      return;
    }

    //print("im netclient init");
    Socket.connect(ServerConfig.instance.imServer , ServerConfig.instance.imPort , timeout: Duration(milliseconds: 30*1000))
    .then((socket){
      print("connect success! ${socket.address} : ${socket.port} => ${socket.remoteAddress} : ${socket.remotePort}");
      _socket = socket;
      _netStatus = NetStatus.online;
      addSocketListener();

      // 
      while(_waitSendMsgs.isNotEmpty){
        Msg msg = _waitSendMsgs.removeAt(0);
        sendMsg(msg);
      }
    })
    .catchError((e){
      _netStatus = NetStatus.offline;
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
        
        print("msg : length = ${msg.length} code = ${msg.code} ");  
        print("content = ${ByteBufUtil.readString(msg.data)}");     
        
        _handleMsg(msg);

        for(MsgCallback callback in callbackList){
          callback.onReceivedMsg(msg);
        }
      },
      onDone: (){
        print("on close socket");
        closeSocket();
      },
      onError: (e){
        print("onError : ${e.toString()}");
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
      print("send msg : ${msg.code} ${msg.length} ${msg.data}");
      var sendBytes = msg.encode();
      print("sendBytes : $sendBytes");
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
        _netStatus = NetStatus.offline;
      }).catchError((e){
        print("close socket error ${e.toString()}");
      });
    }
  }
  
}//end class
