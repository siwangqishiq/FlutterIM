
import 'package:flutter/material.dart';
import 'package:imclient/core/NetClient.dart';
import 'package:imclient/model/Bytebuf.dart';
import 'package:imclient/model/Msg.dart';

class SessionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SessionPageState();
}

class SessionPageState extends State<SessionPage> with MsgCallback {
  String _content = "UnSet";

  @override
  void initState() {
    super.initState();
    NetClient.getInstance().addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _content,
          style: TextStyle(
            fontSize: 40,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("session page dispose");
    NetClient.getInstance().removeListener(this);
    super.dispose();
  }

  @override
  void onReceivedMsg(Msg msg) {
    String str = ByteBufUtil.readString(msg.data);
    setState(() {
     _content = str; 
    });
  }

}//end class
