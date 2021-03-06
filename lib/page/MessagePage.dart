import 'package:flutter/material.dart';
import 'package:imclient/model/Friend.dart';
import 'package:imclient/model/IMMessage.dart';
import 'package:imclient/util/TextUtil.dart';

class P2PMessagePage extends StatefulWidget{
  final Friend _friend;

  P2PMessagePage(this._friend);

  @override
  State<StatefulWidget> createState() => P2PMessageState(_friend);
}

class P2PMessageState extends State<P2PMessagePage>{
  final Friend _friend;

  List<IMMessage> messageList = [];

  P2PMessageState(this._friend);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_friend.displayName()),
        ),
        body: Column(
          children: [
            Expanded(
              child: Text("列表"),
            ),
            Row(
              children: [
                Expanded(
                  flex:5,
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: RaisedButton(
                    child: Text("发送"),
                    onPressed: (){

                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
  }

  //发送文本消息
  void sendTextIMMessage(String content){
    if(TextUtil.isEmpty(content))
      return;
    
    IMMessage imMsg = IMMessage.createTextIMMessage(SessionType.P2P, _friend.uid, content);
    
  }

}//end class