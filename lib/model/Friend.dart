
import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';

///
///好友数据列表
///
class FriendResp extends Codec implements IGenListItem<Friend>{
  int result;
  List<Friend> friendList;
  
  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    result = readInt32(rawData);
    //print("friendResp  result = $result");

    friendList = readList(rawData, this);
    return getReadIndex();
  }

  @override
  Uint8List encode() {
    return null;
  }

  @override
  Friend createListItem() {
    return new Friend();
  }
}//end class

class Friend extends Codec{
  static const int SEX_MALE = 1;
  static const int SEX_FEMALE = 0;


  int uid;
  String account;
  String avator;
  int sex;
  String nick;
  int age;
  String desc;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    uid = readInt64(rawData);
    sex = readInt32(rawData);
    avator = readString(rawData);
    account = readString(rawData);
    nick = readString(rawData);
    age = readInt32(rawData);
    desc = readString(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeInt64(uid));
    result.add(writeInt32(sex));
    result.add(writeString(avator));
    result.add(writeString(account));
    result.add(writeString(nick));
    result.add(writeInt32(age));
    result.add(writeString(desc));

    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  String toString() {
    return "{ uid = $uid , sex = $sex , avator =$avator , account = $account , nick = $nick , age =$age}";
  }
}
