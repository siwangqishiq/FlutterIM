import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/model/Msg.dart';
import 'package:imclient/model/bytebuf.dart';
import 'SessionPage.dart';


class WebSocketRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute>  
      with WidgetsBindingObserver , ClientCallback {
  String netStatusShow;
  String content;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    IMClient.getInstance().init();

    content = "[]";

    IMClient.getInstance().addListener(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if(state == AppLifecycleState.detached){
      print("page dispose()");
      IMClient.getInstance().dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(netStatusShow),
      ),
      body: Center(
        child: Text(content),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SessionPage(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    IMClient.getInstance().removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onReceivedMsg(final Msg msg) {
    String str = ByteBufUtil.readString(msg.data);
    setState(() {
      content = str;
    });
    //print("received msg ${msg.code}");
  }

  @override
  void onNetStatusChange(NetStatus oldStatus, NetStatus newStatus) {
    
  }
}//end class