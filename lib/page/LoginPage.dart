
import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/model/Person.dart';
import 'package:imclient/core/Codes.dart';
import 'package:imclient/util/TextUtil.dart';

//
class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

//
class _LoginPageState extends State<LoginPage> with ClientCallback{
  String _statusContent = "未连接";

  String _account;
  String _pwd;

  bool _loginBtnEnable = false;//提交按钮是否可用

  @override
  void initState(){
    super.initState();
    IMClient.getInstance().addListener(this);
  }

  @override
  void dispose(){
    super.dispose();
    IMClient.getInstance().removeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "输入用户名"
              ),
              onChanged: (text) {//内容改变的回调
                _account = text;
                _onInputTextChange();
              }
            ),

            TextField(
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "输入登录密码",
              ),
              onChanged: (inputPwd) {//内容改变的回调
                _pwd = inputPwd;
                _onInputTextChange();
              }
            ),
            SizedBox(
              height: 15,
            ),
            ButtonTheme(
              minWidth:double.infinity,
              child: RaisedButton(
                onPressed: _loginBtnEnable?_onClickLoginButton:null,
                textColor: Colors.white,
                color: Colors.blue,
                child:Text("登录"),
              )
            )
          ],
        ),
      )
      
      
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  //输入内容改变  联动修改提交按钮状态
  void _onInputTextChange(){
    print("accout = $_account  pwd = $_pwd");
    bool enbaleSubmit = !TextUtil.isEmpty(_account) && !TextUtil.isEmpty(_pwd);

    if(enbaleSubmit != _loginBtnEnable){
      setState(() {
        _loginBtnEnable = enbaleSubmit;
      });
    }
  }

  //点击登录按钮
  void _onClickLoginButton(){

  }

  @override
  void onNetStatusChange(NetStatus oldStatus, NetStatus newStatus) {
    String content;
    switch(newStatus){
      case NetStatus.offline:
        content = "未连接";
        break;
      case NetStatus.connecting:
        content = "连接中...";
        break;
      case NetStatus.online:
        content = "已连接";
        break;
    }//end switch

    print("content : $content");
    setState(() {
      _statusContent = content;
    });
  }
  
  @override
  void onReceivedMsg(Msg msg) {
    if(msg.code == Codes.CODE_PERSON_RESP){
      PesonResp pesonResp = PesonResp();
      pesonResp.decode(msg.data);

      DateTime t = DateTime.fromMillisecondsSinceEpoch(pesonResp.time);

      String info = "${t.toLocal().toString()}   ${pesonResp.content}";
      print("$info");
    }
  }

}//
