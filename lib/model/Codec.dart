import 'dart:typed_data';
import 'dart:convert' show utf8;

abstract class Codec {
  int _readIndex = 0;

  //转为字节流
  Uint8List encode();

  //字节流转为对象
  void decode(Uint8List rawData);

  //重置已读索引
  void resetReadIndex(){
    _readIndex = 0;
  }

  //向字节流中写入一个32位int
  Uint8List writeInt32(int value){
    ByteData data = ByteData(4);
    data.setInt32(0, value , Endian.little);
    return data.buffer.asUint8List();
  }

  //
  Uint8List writeString(String str){
    if(str == null || str.isEmpty){
      return writeInt32(0);
    }

    List<Uint8List> result = [];

    Uint8List strUint8List = utf8.encode(str);
    result.add(writeInt32(strUint8List.length));
    result.add(strUint8List);
    
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  int readInt32(Uint8List bytes){
    int result = bytes.sublist(_readIndex).buffer.asInt32List()[0];
    _readIndex += 4;
    return result;
  }

  String readString(Uint8List bytes){
    int len = bytes.sublist(_readIndex).buffer.asInt32List()[0];
    print("$_readIndex len = $len");
    String readString = utf8.decode(bytes.sublist(_readIndex + 4 , _readIndex + 4 + len));
    _readIndex += (4 + len); //string 长度 + 数据长度
    return readString;
  }
}//end class
