
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
  int resultCode;
  String token;

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    
    resultCode = readInt32(rawData);
    token = readString(rawData);
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];

    result.add(writeInt32(resultCode));
    result.add(writeString(token));
    
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }
}
