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

  //
  static List<int> convertUint8ListToMutable(Uint8List data){
    List<int> result = <int>[];
    if(data == null)
      return result;

    for(int i = 0 ; i<data.length;i++){
      result.add(data[i]);
    }
    return result;
  }

  static int readInt32(List<int> list){
    Uint8List bytes = Uint8List.fromList(list);
    int result = bytes.sublist(0).buffer.asInt32List()[0];
    return result;
  }
}


