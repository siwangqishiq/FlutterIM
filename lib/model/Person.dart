
import 'dart:typed_data';
import 'package:imclient/model/Codec.dart';

class PesonResp extends Codec{
  String content;
  num time;

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(content));
    result.add(writeInt64(time));
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();
    
    content = readString(rawData);
    time = readInt64(rawData);
  }
}

class Person extends Codec{
  String name;
  int age;
  String desc;

  Person({this.name , this.age = 31, this.desc = "你是个好人"});

  factory Person.build(Uint8List rawData) {
    Person p = new Person();
    p.decode(rawData);
    return p;
  }

  @override
  Uint8List encode() {
    List<Uint8List> result = [];
    result.add(writeString(name));
    result.add(writeInt32(age));
    result.add(writeString(desc));
    return Uint8List.fromList(result.expand((x)=>x).toList());
  }

  @override
  void decode(Uint8List rawData) {
    resetReadIndex();

    name = readString(rawData);
    age = readInt32(rawData);
    desc = readString(rawData);
  }
}//end class
