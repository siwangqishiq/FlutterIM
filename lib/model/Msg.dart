import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';
import 'package:imclient/util/GenUtil.dart';

//通信msg
class Msg extends Codec {
  int length;
  int uuid;
  int code;
  Uint8List data;

  bool resend = false;

  Msg();

  static Msg buildMsg(int code, Codec data) {
    final Msg msg = new Msg();

    msg.code = code;
    msg.uuid = GenUtil.genUuid();
    msg.length = 4 + 4 + 8;

    msg.resend = data.needResend();

    if (data != null) {
      Uint8List dataBytes = data.encode();
      msg.data = dataBytes;

      if (msg.data != null) {
        msg.length += msg.data.length;
      }
    }
    return msg;
  }

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    length = readInt32(rawData);
    uuid = readInt64(rawData);
    code = readInt32(rawData);

    data = rawData.sublist(4 + 4 + 8);

    return getReadIndex();
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];

    result.add(writeInt32(length));
    result.add(writeInt64(uuid));
    result.add(writeInt32(code));

    result.add(data);

    return Uint8List.fromList(result.expand((x) => x).toList());
  }
} //end class
