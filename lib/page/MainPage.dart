
import 'package:flutter/material.dart';

//主界面
class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

//main page
class _MainPageState extends State {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("主界面"),
      ),
      body: Center(
        child: Text(
          "最近联系人",
          style: TextStyle(
            fontSize: 30.0
          ),
        ),
      ),
    );
  }

}//end class

