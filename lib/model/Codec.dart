import 'dart:typed_data';
import 'dart:convert' show utf8;

abstract class Codec {
  static const int RESULT_CODE_SUCCESS = 1;
  static const int RESULT_CODE_ERROR = -1;

  int _readIndex = 0;

  //转为字节流
  Uint8List encode();

  //字节流转为对象
  void decode(Uint8List rawData);

  int getCode(){
    return 0;
  }

  //重置已读索引
  void resetReadIndex(){
    _readIndex = 0;
  }

  int getReadIndex() => _readIndex;

  //向字节流中写入一个32位int
  Uint8List writeInt32(int value){
    ByteData data = ByteData(4);
    data.setInt32(0, value , Endian.little);
    return data.buffer.asUint8List();
  }

  Uint8List writeInt64(int value){
    ByteData data = ByteData(8);
    data.setInt64(0, value , Endian.little);
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

  static int readInt32NoMoveIndex(Uint8List bytes){
    int result = bytes.sublist(0).buffer.asInt32List()[0];
    return result;
  }

  num readInt64(Uint8List bytes){
    num result = bytes.sublist(_readIndex).buffer.asInt64List()[0];
    _readIndex += 8;
    return result;
  }

  String readString(Uint8List bytes){
    //print("readString $bytes");
    int len = bytes.sublist(_readIndex).buffer.asInt32List()[0];
    //print("$_readIndex len = $len");
    String readString = utf8.decode(bytes.sublist(_readIndex + 4 , _readIndex + 4 + len));
    _readIndex += (4 + len); //string 长度 + 数据长度

    return readString;
  }
}//end class
