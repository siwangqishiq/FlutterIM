import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:imclient/model/Friend.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/core/IMClient.dart';

import 'BaseState.dart';

///
/// 好友名片页
///
class FriendCardPage extends StatefulWidget{
  final Friend _friend;
  
  FriendCardPage(this._friend);

  @override
  State<StatefulWidget> createState() => _FriendCardPageState(_friend);
}

class _FriendCardPageState extends BaseState<FriendCardPage>{
  final Friend friend;

  _FriendCardPageState(this.friend);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${friend.nick}"),
      ),
      body: Column(
        children: <Widget>[
          Hero(
            tag: friend.avator,
            child: Image.network(
              friend.avator,
              width: double.infinity,
              height: 230.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Align(
              alignment:Alignment.topLeft,
              child: Text(friend.nick,style: TextStyle(fontSize: 28.0),textAlign:TextAlign.left),
            )
          ),
          Divider(
            height: 1.0,
            color: Colors.white,
            indent: 10.0,
            endIndent: 10.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Align(
              alignment:Alignment.topLeft,
              child: Text(
                friend.desc,
                style: TextStyle(fontSize: 18.0,color: Colors.grey),
                textAlign:TextAlign.left
              ),
            )
          ),
          Expanded(child: SizedBox(height: double.infinity)),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: MaterialButton(
              child:Text("发送消息",style: TextStyle(color:Colors.white)),
              color: Colors.blue,
              minWidth: double.infinity,
              onPressed: (){
              },
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: MaterialButton(
              child:Text("删除好友",style: TextStyle(color:Colors.white)),
              minWidth: double.infinity,
              color: Colors.red,
              onPressed: (){
              },
            )
          )
        ],
      ),
    );
  }

  @override
  void onNetStatusChange(NetStatus oldStatus, NetStatus newStatus) {
    
  }

  @override
  void onReceivedMsg(Msg msg) {

  }
  
}//end class