
import 'package:imclient/model/Friend.dart';

///
///好友数据本地Cache
///
class FriendDataCache{
  static FriendDataCache _instance;

  static FriendDataCache instance(){
    if(_instance == null){
      _instance = new FriendDataCache();
    }
    return _instance;
  }

  List<Friend> _list = [];

  // 重新添加好友数据
  bool reAddAllFriend(List<Friend> friendList){
    _list.clear();

    _list.addAll(friendList);
    return true;
  }

  List<Friend> get() => _list;
}//end class