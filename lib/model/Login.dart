
import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';
import 'package:imclient/core/Codes.dart';

class LoginReq extends Codec{
  String account;
  String password;

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    
    account = readString(rawData);
    password = readString(rawData);
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(account));
    result.add(writeString(password));
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  int getCode(){
    return Codes.CODE_LOGIN_REQ;
  }
}

class LoginResp extends Codec {
  static const int RESULT_CODE_SUCCESS = 1;
  static const int RESULT_CODE_ERROR = -1;

  int resultCode;
  String token;
  String account;
  int uid;
  String avator;

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    
    resultCode = readInt32(rawData);
    token = readString(rawData);
    account = readString(rawData);
    uid = readInt64(rawData);
    avator = readString(rawData);
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];

    result.add(writeInt32(resultCode));
    result.add(writeString(token));
    result.add(writeString(account));
    result.add(writeInt64(uid));
    result.add(writeString(avator));
    
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  int getCode(){
    return Codes.CODE_LOGIN_RESP;
  }
}
