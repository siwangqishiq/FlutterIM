
import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/page/BaseState.dart';

class SettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends BaseState<SettingPage> {
  static const int TAB_INDEX_SETTING =2;

  String _content = "设置";

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
            color: Colors.black,
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
