
import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/page/BaseState.dart';

class ContactsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ContactsPageState();
}

class ContactsPageState extends BaseState<ContactsPage> {
  static const int TAB_INDEX_CONTACT =1;

  String _content = "好友";

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  void onReceivedMsg(Msg msg) {
    
  }

  @override
  void onNetStatusChange(NetStatus oldStatus, NetStatus newStatus) {
    
  }
}//end class
