import 'dart:typed_data';
import 'dart:convert' show utf8;
import 'package:imclient/model/Msg.dart';


class ByteBufUtil {

  static Msg readMsg(Uint8List rawData){
    if(rawData == null)
      return null;
    
    Msg msg = new Msg();
    msg.decode(rawData);

    // print("======================================");
    // print(msg);
    // print("======================================");
    return msg;
  }

  static String readString(Uint8List data){
    return utf8.decode(data);
    //return String.fromCharCodes(data);
  }
}


