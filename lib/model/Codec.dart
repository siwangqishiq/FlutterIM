import 'dart:typed_data';
import 'dart:convert' show utf8;

abstract class Codec {
  static const int RESULT_CODE_SUCCESS = 1;
  static const int RESULT_CODE_ERROR = -1;

  int sendTimes = 0;

  int _readIndex = 0;
  SendCallback _callback;

  //转为字节流
  Uint8List encode();

  //字节流转为对象 返回读取的字节数
  int decode(Uint8List rawData);

  //设置事件回调
  void setCallback(SendCallback cb) {
    _callback = cb;
  }

  SendCallback getCallback() {
    return _callback;
  }

  int getCode() {
    return 0;
  }

  //是否有超时重发确认机制  默认没有
  bool needResend() {
    return false;
  }

  //重置已读索引
  void resetReadIndex() {
    _readIndex = 0;
  }

  int getReadIndex() => _readIndex;

  //向字节流中写入一个32位int
  Uint8List writeInt32(int value) {
    ByteData data = ByteData(4);
    data.setInt32(0, value, Endian.little);
    return data.buffer.asUint8List();
  }

  Uint8List writeInt64(int value) {
    ByteData data = ByteData(8);
    data.setInt64(0, value, Endian.little);
    return data.buffer.asUint8List();
  }

  String readString(Uint8List bytes) {
    //print("readString $bytes");
    int len = bytes.sublist(_readIndex).buffer.asInt32List()[0];
    //print("$_readIndex len = $len");
    String readString =
        utf8.decode(bytes.sublist(_readIndex + 4, _readIndex + 4 + len));
    _readIndex += (4 + len); //string 长度 + 数据长度

    return readString;
  }

  //
  Uint8List writeString(String str) {
    if (str == null || str.isEmpty) {
      return writeInt32(0);
    }

    List<Uint8List> result = [];

    Uint8List strUint8List = utf8.encode(str);
    result.add(writeInt32(strUint8List.length));
    result.add(strUint8List);

    return Uint8List.fromList(result.expand((x) => x).toList());
  }

  int readInt8(Uint8List bytes) {
    int result = bytes.sublist(_readIndex).buffer.asInt8List()[0];
    _readIndex += 1;
    return result;
  }

  Uint8List writeInt8(int value) {
    ByteData data = ByteData(1);
    data.setInt8(0, value);
    return data.buffer.asUint8List();
  }

  int readInt32(Uint8List bytes) {
    int result = bytes.sublist(_readIndex).buffer.asInt32List()[0];
    _readIndex += 4;
    return result;
  }

  //写入一个list
  Uint8List writeList<T extends Codec>(List<T> list) {
    if (list == null) {
      return writeInt32(0);
    } else {
      List<Uint8List> result = [];
      result.add(writeInt32(list.length));
      for (int i = 0; i < list.length; i++) {
        Codec item = list[i];
        result.add(item.encode());
      } //end for i
      return Uint8List.fromList(result.expand((x) => x).toList());
    }
  }

  //读取一个List
  List<T> readList<T extends Codec>(Uint8List bytes, IGenListItem genCallback) {
    int listSize = readInt32(bytes);
    //print("listSize = $listSize");

    List<T> list = [];
    if (listSize > 0) {
      for (int i = 0; i < listSize; i++) {
        if (genCallback != null) {
          T item = genCallback.createListItem();

          //print("read list readIndex = $_readIndex");
          int readByteCount = item.decode(bytes.sublist(_readIndex));
          _readIndex += readByteCount;

          list.add(item);
        }
      } //end for i
    }
    return list;
  }

  // static int readInt32NoMoveIndex(Uint8List bytes){
  //   int result = bytes.sublist(0).buffer.asInt32List()[0];
  //   return result;
  // }

  num readInt64(Uint8List bytes) {
    num result = bytes.sublist(_readIndex).buffer.asInt64List()[0];
    _readIndex += 8;
    return result;
  }
} //end class

//生成列表中的实体对象
abstract class IGenListItem<T extends Codec> {
  T createListItem();
}

//发送消息时 产生的事件回调
abstract class SendCallback {
  //远端成功接收
  void onSendSuccess(Codec msg);

  //重试超过指定次数仍然无回应 则报错 回调
  void onSendError(Codec msg);
}
