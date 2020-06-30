import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:imclient/model/bytebuf.dart';

import '../config.dart';

typedef OnMsgCallback = bool Function(Msg msg);

class NetClient{
  static NetClient instance;

  Socket _socket;

  List<OnMsgCallback> callbackList = [];

  static NetClient getInstance(){
    if(instance == null){
      instance = new NetClient();
    }

    return instance;
  }


  void init(){
    connectServer();
  }

  void connectServer(){
    //print("im netclient init");
    Socket.connect(ServerConfig.instance.IM_Server , ServerConfig.instance.IM_Port)
    .then((socket){
      print("connect success! ${socket.address} : ${socket.port} => ${socket.remoteAddress} : ${socket.remotePort}");
      _socket = socket;
      addListener();
    })
    .catchError((e){
      print("connect error ${e.toString()}");
    });
  }

  void addListener(){
    if(_socket == null)
      return;

    _socket.listen(
      (Uint8List data){
        print("received (${data.lengthInBytes}   |   ${data.length} ): ${data.runtimeType}");
        //print("content = ${ByteBufUtil.readString(data)}");
        Msg msg = ByteBufUtil.readMsg(data);
        print("msg : length = ${msg.length} code = ${msg.code} ");  
        print("content = ${ByteBufUtil.readString(msg.data)}");      
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
