
import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';

class FriendResp extends Codec{
  int result;
  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    result = readInt32(rawData);
  }

  @override
  Uint8List encode() {
    return null;
  }
}

class Friend extends Codec{
  int uid;
  String account;
  String avator;
  int sex;
  String nick;
  int age;

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    
    uid = readInt32(rawData);
    account = readString(rawData);
    avator = readString(rawData);
    sex = readInt32(rawData);
    nick = readString(rawData);
    age = readInt32(rawData);
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
