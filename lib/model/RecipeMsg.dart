import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';
import 'package:imclient/util/GenUtil.dart';

///
/// 具有超时重发能力的msg
///
abstract class RecipeMsg extends Codec{
  int uuid;

  //生成
  static int gen16Uuid(){
    return GenUtil.genUuid();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeInt64(uuid));

    encodeReciptMsgBody(result);

    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();
    uuid = readInt64(rawData);

    decodeRecipeMsgBody(rawData);

    return getReadIndex();
  }

  //子类实现 编码消息体
  Uint8List encodeReciptMsgBody(List<Uint8List> result);

  //子类实现  解码消息体
  int decodeRecipeMsgBody(Uint8List rawData);

}//end class