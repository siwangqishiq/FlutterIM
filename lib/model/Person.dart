
import 'dart:typed_data';
import 'package:imclient/model/Codec.dart';

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

    print("1");
    name = readString(rawData);
    print("2");
    age = readInt32(rawData);
    print("3");
    desc = readString(rawData);
    print("4");
  }
}//end class
