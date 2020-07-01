import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';

//通信msg
class Msg extends Codec {
  int length;
  int code;
  Uint8List data;

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();

    length = readInt32(rawData);
    code = readInt32(rawData);

    data = rawData.sublist(8);
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];

    result.add(writeInt32(length));
    result.add(writeInt32(code));
    result.add(data);

    return Uint8List.fromList(result.expand((x)=>x).toList());
  }
}//end class