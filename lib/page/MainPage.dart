
import 'package:flutter/material.dart';
import 'package:imclient/page/ContactsPage.dart';
import 'package:imclient/page/SessionPage.dart';
import 'package:imclient/page/SettingPage.dart';

//主界面
class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

//main page
class _MainPageState extends State {
  int mTabIndex = SessionPageState.TAB_INDEX_SESSION;

  List<StatefulWidget> mMainTabs = <StatefulWidget>[
    SessionPage(),ContactsPage(),SettingPage()
  ];

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
        child: mMainTabs[mTabIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mTabIndex,
        type:BottomNavigationBarType.fixed,
        onTap: _switchTab,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                title: Text("对话"),
                icon: Icon(Icons.chat)
            ),
            BottomNavigationBarItem(
                title: Text("好友"),
                icon: Icon(Icons.list)
            ),
            BottomNavigationBarItem(
                title: Text("设置"),
                icon: Icon(Icons.settings)
            )
          ]
      ),
    );
  }

  _switchTab(int newTabIndex){
    setState(() {
      mTabIndex = newTabIndex;
    });
  }
}//end class

