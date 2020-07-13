
import 'package:imclient/model/Friend.dart';

//好友数据缓存
class FriendDataCache{
  static FriendDataCache _instance;

  static FriendDataCache getInstance(){
    if(_instance == null){
      _instance = new FriendDataCache();
    }
    return _instance;
  }

  Map<int , Friend> _friendData = {};

  //清空原有数据 加入新的好友列表
  void refreshAll(List<Friend> _list){
    _friendData.clear();
    _list.forEach((element) {
      _friendData[element.uid] = element;
    });
  }
}//end class
