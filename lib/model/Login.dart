import 'dart:typed_data';

import 'package:imclient/core/Account.dart';
import 'package:imclient/model/AuthBaseBean.dart';
import 'package:imclient/model/Codec.dart';
import 'package:imclient/core/Codes.dart';

class LoginReq extends Codec {
  String account;
  String password;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    account = readString(rawData);
    password = readString(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(account));
    result.add(writeString(password));
    return Uint8List.fromList(result.expand((x) => x).toList());
  }

  @override
  int getCode() {
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
  String name;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    resultCode = readInt32(rawData);
    token = readString(rawData);
    account = readString(rawData);
    uid = readInt64(rawData);
    avator = readString(rawData);
    name = readString(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];

    result.add(writeInt32(resultCode));
    result.add(writeString(token));
    result.add(writeString(account));
    result.add(writeInt64(uid));
    result.add(writeString(avator));
    result.add(writeString(name));

    return Uint8List.fromList(result.expand((x) => x).toList());
  }

  @override
  int getCode() {
    return Codes.CODE_LOGIN_RESP;
  }
}

//退出登录
class LoginOutReq extends AuthBaseBean {
  int uid;

  LoginOutReq(this.uid) : super(Account.getToken());

  @override
  int decodeModel(Uint8List rawData) {
    uid = readInt64(rawData);
    return getReadIndex();
  }

  @override
  Uint8List encodeModel(List<Uint8List> result) {
    result.add(writeInt64(uid));
    return null;
  }

  @override
  int getCode() {
    return Codes.CODE_LOGIN_OUT_REQ;
  }
}

/**
 * 注销登录消息 响应
 */
class LoginOutResp extends Codec {
  int resultCode;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    resultCode = readInt32(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeInt32(resultCode));
    return Uint8List.fromList(result.expand((x) => x).toList());
  }

  @override
  int getCode() {
    return Codes.CODE_LOGIN_OUT_RESP;
  }
}

//自动登录 请求
class AutoLoginReq extends AuthBaseBean{
  int synType = 1;

  AutoLoginReq() : super(Account.getToken());

  @override
  int decodeModel(Uint8List rawData) {
    synType = readInt32(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encodeModel(List<Uint8List> result) {
    result.add(writeInt32(synType));
    return null;
  }

  @override
  int getCode() {
    return Codes.CODE_AUTO_LOGIN_REQ;
  }
}

class AutoLoginResp extends Codec{
  int resultCode;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    resultCode = readInt32(rawData);

    return getReadIndex();
  }
  
  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeInt32(resultCode));
    return Uint8List.fromList(result.expand((x) => x).toList());
  }

  @override
  int getCode() {
    return Codes.CODE_AUTO_LOGIN_REQ;
  }
}
