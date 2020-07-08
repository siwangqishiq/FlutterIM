
import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Bytebuf.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/page/BaseState.dart';

class SessionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SessionPageState();
}

class SessionPageState extends BaseState<SessionPage> {
  static const int TAB_INDEX_SESSION =0;

  static String content = "会话";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          content,
          style: TextStyle(
            fontSize: 40,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  @override
  void onReceivedMsg(Msg msg) {

  }

  @override
  void onNetStatusChange(NetStatus oldStatus, NetStatus newStatus) {
    
  }

}//end class
