import 'package:imclient/model/Msg.dart';

///
/// 接收msg相应操作
abstract class IMAction{
  //处理消息
  void handleMsg(Msg msg);

  //是否回调 默认需要
  bool needCallback(){
    return true;
  }
}
