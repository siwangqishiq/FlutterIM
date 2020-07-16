import 'package:imclient/im/Action.dart';
import 'package:imclient/model/Codec.dart';
import 'package:imclient/model/Friend.dart';
import 'package:imclient/model/Msg.dart';

//获取好友数据
class GetFriendListAction extends IMAction{
  @override
  void handleMsg(Msg msg) {
    print("获取好友数据");
    FriendResp resp = new FriendResp();
    resp.decode(msg.data);
    if(resp.result == Codec.RESULT_CODE_SUCCESS){
      onReceivedFriendList(resp.friendList);
    }
  }

  void onReceivedFriendList(List<Friend> friendList){

  }
}
