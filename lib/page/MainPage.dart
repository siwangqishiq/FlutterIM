import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imclient/page/ContactsPage.dart';
import 'package:imclient/page/LoginPage.dart';
import 'package:imclient/page/SessionPage.dart';
import 'package:imclient/page/SettingPage.dart';
import 'package:imclient/core/IMClient.dart';

//主界面
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

//main page
class _MainPageState extends State with LoginOutCallback {
  String _title = SessionPageState.content;
  int mTabIndex = SessionPageState.TAB_INDEX_SESSION;

  List<StatefulWidget> mMainTabs = <StatefulWidget>[
    SessionPage(),
    ContactsPage(),
    SettingPage()
  ];

  @override
  void initState() {
    super.initState();
    IMClient.getInstance().addLoginOutCallback(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: mMainTabs[mTabIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: mTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          onTap: _switchTab,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(title: Text("对话"), icon: Icon(Icons.chat)),
            BottomNavigationBarItem(
                title: Text("好友"), icon: Icon(Icons.contact_mail)),
            BottomNavigationBarItem(
                title: Text("设置"), icon: Icon(Icons.settings))
          ]),
    );
  }

  _switchTab(int newTabIndex) {
    setState(() {
      mTabIndex = newTabIndex;
      switch (mTabIndex) {
        case SessionPageState.TAB_INDEX_SESSION:
          _title = SessionPageState.content;
          break;
        case ContactsPageState.TAB_INDEX_CONTACT:
          _title = ContactsPageState.content;
          break;
        case SettingPageState.TAB_INDEX_SETTING:
          _title = SettingPageState.content;
          break;
      } //end switch
    });
  }

  @override
  void loginOutError() {
    FlutterToast.showToast(msg: "注销失败");
  }

  @override
  void loginOutSuccess() async {
    await Navigator.of(context).pop();

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LoginPage()
    ));
  }

  @override
  void dispose(){
    IMClient.getInstance().clearLoginOutCallback();
    super.dispose();
  }
} //end class
