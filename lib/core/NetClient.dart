import 'dart:io';
import 'dart:typed_data';
import 'package:imclient/env/ServerConfig.dart';
import 'package:imclient/model/bytebuf.dart';
import 'package:imclient/model/Msg.dart';

//typedef OnMsgCallback = bool Function(Msg msg);

abstract class MsgCallback{
  void onReceivedMsg(Msg msg);
}

class NetClient{
  static NetClient instance;

  Socket _socket;

  List<MsgCallback> callbackList = [];

  static NetClient getInstance(){
    if(instance == null){
      instance = new NetClient();
    }

    return instance;
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
    //print("im netclient init");
    Socket.connect(ServerConfig.instance.imServer , ServerConfig.instance.imPort , timeout: Duration(milliseconds: 30*1000))
    .then((socket){
      print("connect success! ${socket.address} : ${socket.port} => ${socket.remoteAddress} : ${socket.remotePort}");
      _socket = socket;
      addSocketListener();
    })
    .catchError((e){
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

        for(MsgCallback callback in callbackList){
          callback.onReceivedMsg(msg);
        }
      },
      onDone: (){
        print("on close socket");
      },
      onError: (e){
        print("onError : ${e.toString()}");
      },  
      cancelOnError: false,
    );
  }

  void sendMsg(){
    if(_socket == null)
      return;

    
  }

  void dispose(){
    print("im netclient dispose");
    if(_socket != null){
      _socket.close().then((r){
        print("close socket success");
        _socket = null;
      }).catchError((e){
        print("close socket error ${e.toString()}");
      });
    }
  }
  
}//end class
