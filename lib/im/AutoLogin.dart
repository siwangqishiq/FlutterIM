import 'package:fluttertoast/fluttertoast.dart';
import 'package:imclient/im/Action.dart';
import 'package:imclient/model/Msg.dart';

///
///自动登录
///

class AutoLoginAction extends IMAction{
  @override
  void handleMsg(Msg msg) {
    print("自动登录 success");
    FlutterToast.showToast(msg: "自动登录成功");
  }
}
