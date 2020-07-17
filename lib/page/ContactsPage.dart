import 'package:flutter/material.dart';
import 'package:imclient/core/Codes.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/im/FriendDataCache.dart';
import 'package:imclient/model/Friend.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/page/BaseState.dart';

class ContactsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ContactsPageState();
}

class ContactsPageState extends BaseState<ContactsPage> {
  static const int TAB_INDEX_CONTACT =1;

  static const String content = "好友";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: ListView.builder(
          itemCount: FriendDataCache.instance().get().length,
          itemBuilder: _craeteContactItem
        ),
      ),
    );
  }

  //创建每一项
  Widget _craeteContactItem(BuildContext context, int index){
    final Friend itemData = FriendDataCache.instance().get()[index];
    return Text(itemData.nick);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onReceivedMsg(Msg msg) {
    if(msg.code == Codes.CODE_FRIEND_LIST_RESP){//更新了好友列表数据
      setState(() {});
    }
  }

  @override
  void onNetStatusChange(NetStatus oldStatus, NetStatus newStatus) {
    
  }
}//end class
