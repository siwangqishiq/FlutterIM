
import 'package:flutter/material.dart';
import 'package:imclient/core/Account.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Friend.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/page/BaseState.dart';

class SettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends BaseState<SettingPage> {
  static const int TAB_INDEX_SETTING =2;

  static const String content = "设置";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("--->${Account.getAvator()}");
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment:Alignment.center,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(Account.getAvator()),
                backgroundColor:Colors.black12,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment:Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Account.sex==Friend.SEX_FEMALE? "assets/images/icon_female.png":"assets/images/icon_male.png",width: 20.0,height: 20.0,),
                  SizedBox(width: 10.0,),
                  Text(Account.name,style: TextStyle(fontSize: 25.0)),
                ],
              )
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment:Alignment.center,
              child: Text(Account.desc,style: TextStyle(fontSize: 15.0 ,color: Colors.grey)),
            ),
            Expanded(
              child: SizedBox(
              ),
            ),
          ButtonTheme(
              minWidth:double.infinity,
              child: FlatButton(
                onPressed: (){
                  _loginOut();
                },
                textColor: Colors.white,
                color: Colors.redAccent,
                padding: EdgeInsets.all(8),
                child:Text("退出登录" , style:TextStyle(fontSize: 18.0)),
              )
            )
          ],
        )
      ),
    );
  }

  void _loginOut(){
    showDialog<bool>(
        context: context ,
        builder: (context){
          return AlertDialog(
            content: Text("您确定要退出登录吗?"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              FlatButton(
                child: Text("退出登录"),
                onPressed: () {
                  IMClient.getInstance().loginOut();
                  Navigator.of(context).pop();
                }, //
              )
            ],
          );
        }
     );
  }

  void _doLoginOut(){

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
