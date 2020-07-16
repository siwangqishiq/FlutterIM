import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';

/**
 * 登录后  需要传token标示自身身份的bean
 */
class AuthBaseBean extends Codec{
  String token;

  AuthBaseBean(this.token);

  int decodeModel(Uint8List rawData){
    return 0;
  }

  Uint8List encodeModel(List<Uint8List> result){
    return null;
  }

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    token = readString(rawData);

    decodeModel(rawData);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(token));

    encodeModel(result);
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

}//end class
