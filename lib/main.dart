import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:imclient/core/NetClient.dart';
import 'package:imclient/page/pages.dart';
import 'dart:convert' show utf8;
import 'model/Person.dart';

void main() =>runApp(MyApp());

void testUnit(){
  print("init app");

  String str ="毛利兰";
  Uint8List strUintList = utf8.encode(str);
  print("strUintList : $strUintList");
  print("strUintList decode : ${utf8.decode(strUintList)}");
  Person p = new Person(name:str);
  Uint8List pData = p.encode();
  print("pData : $pData");

  Person decodePerson = Person.build(pData);
  print("decodePerson  ${decodePerson.name}  ${decodePerson.age} ${decodePerson.desc}");
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
      home: WebSocketRoute(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    super.initState();
    NetClient.getInstance().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'IMClient',
            ),
          ],
        ),
      ),
    );
  }
}
