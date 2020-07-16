
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
  int uid;
  String account;
  String avator;
  int sex;
  String nick;
  int age;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    uid = readInt32(rawData);
    account = readString(rawData);
    avator = readString(rawData);
    sex = readInt32(rawData);
    nick = readString(rawData);
    age = readInt32(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeInt32(uid));
    result.add(writeString(account));
    result.add(writeString(avator));
    result.add(writeInt32(sex));
    result.add(writeString(nick));
    result.add(writeInt32(age));
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }
}
