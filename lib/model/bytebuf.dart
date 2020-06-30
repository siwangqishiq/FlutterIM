
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert' show utf8;


class Msg{
  int length;
  int code;
  Uint8List data;
}

class ByteBufUtil {

  static Msg readMsg(Uint8List rawData){
    if(rawData == null)
      return null;
    

    ByteBuffer buf = rawData.buffer;

    // print("======================================");
    // print(rawData);
    // print(buf);
    // print("======================================");

    
    
    var int32Buf = buf.asUint32List();
    int length = int32Buf[0];
    int code = int32Buf[1];

    print("length = $length , code = $code");

    Uint8List data = buf.asUint8List(8);
    print("======================================");
    print(data);
    print("======================================");
    Msg msg = new Msg();
    msg.length = length;
    msg.code = code;
    msg.data = data;

    return msg;
  }

  static String readString(Uint8List data){
    return utf8.decode(data);
    //return String.fromCharCodes(data);
  }
}

