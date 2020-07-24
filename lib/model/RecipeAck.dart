import 'dart:typed_data';

import 'package:imclient/core/Codes.dart';
import 'package:imclient/model/Codec.dart';

class RecipeAck extends Codec{
  int uuid;

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    uuid = readInt64(rawData);
    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeInt64(uuid));
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  int getCode(){
    return Codes.CODE_RECIPE_ACK;
  }

}

//测试重发消息
class RecipeHello extends Codec{
  String content;
  
  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    content = readString(rawData);
    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(content));
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  int getCode(){
    return Codes.CODE_RECIPE_HELLO;
  }

  bool needResend(){
    return true;
  }
}