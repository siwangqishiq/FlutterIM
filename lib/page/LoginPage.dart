
import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/model/Person.dart';

//
class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

//
class _LoginPageState extends State<LoginPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Center(
        child: Text("登录"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Person p = new Person();
          p.age = 21;
          p.name = "工藤新一";
          p.desc = "平成年间的 ，福尔摩斯啊";

          Msg msg = Msg.buildMsg(10001 , p);
          IMClient.getInstance().sendMsg(msg);
        },
        child: Icon(Icons.add),
      ),
    );
  }

}//
