import 'dart:ffi';
import 'dart:typed_data';

import 'package:imclient/model/Codec.dart';

//通信msg
class Msg extends Codec {
  int length;
  int code;
  Uint8List data;

  Msg();

  static Msg buildMsg(int code, Codec data){
    Msg msg = new Msg();
    msg.code = code;
    msg.length = 8; 
    if(data != null){
      Uint8List dataBytes = data.encode();
      msg.data = dataBytes;
            
      if(msg.data != null){
        msg.length += msg.data.length;
      }
    }
    return msg;
  }

  @override
  int decode(Uint8List rawData) {
    resetReadIndex();

    length = readInt32(rawData);
    code = readInt32(rawData);

    data = rawData.sublist(8);
    
    return getReadIndex();
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