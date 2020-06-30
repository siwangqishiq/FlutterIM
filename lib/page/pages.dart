import 'package:flutter/material.dart';
import 'package:imclient/core/NetClient.dart';


class WebSocketRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute>  with WidgetsBindingObserver {
  String content;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NetClient.getInstance().init();

    content = "<>";
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if(state == AppLifecycleState.inactive){
      print("page dispose()");
      NetClient.getInstance().dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body: Center(
        child: Text(content),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        },
        child: Icon(Icons.navigation),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}//end class