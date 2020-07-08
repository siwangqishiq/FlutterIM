import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';

/**
 * 登录后  需要传token标示自身身份的bean
 */
class AuthBaseBean extends Codec{
  String token;

  AuthBaseBean(this.token);

  void decodeModel(Uint8List rawData){
  }

  Uint8List encodeModel(List<Uint8List> result){
  }

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    token = readString(rawData);

    decodeModel(rawData);
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(token));

    encodeModel(result);
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

}//end class
