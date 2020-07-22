import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/page/LoginPage.dart';
import 'package:imclient/page/MainPage.dart';
import 'package:imclient/page/pages.dart';
import 'package:imclient/util/GenUtil.dart';
import 'dart:convert' show utf8;
import 'core/Account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //确保flutter环境已经完全启动  否则后面会报错
  unitTest();
  appInit();
  runApp(MyApp());
}

void unitTest(){
  // for(int i=0 ;i < 100;i++){
  //   print(GenUtil.get16Uuid());
  // }

  // LruCache<String , String> cache = LruCache();

  LruCache<Long,String> cache = LruCache<Long,String>();
}

void appInit() async{
  await Account.loadAccount();

  print("Account isLogin = ${Account.isLogin()}");
  if(Account.isLogin()){//自动登录
    IMClient.getInstance().autoLogin();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: '客户端'),
      home: Account.isLogin()?MainPage():LoginPage(),
    );
  }
}

// void testUnit(){
//   print("init app");

//   String str ="毛利兰";
//   Uint8List strUintList = utf8.encode(str);
//   print("strUintList : $strUintList");
//   print("strUintList decode : ${utf8.decode(strUintList)}");
//   Person p = new Person(name:str);
//   Uint8List pData = p.encode();
//   print("pData : $pData");

//   Person decodePerson = Person.build(pData);
//   print("decodePerson  ${decodePerson.name}  ${decodePerson.age} ${decodePerson.desc}");
// }