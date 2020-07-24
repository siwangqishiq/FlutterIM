import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class GenUtil{
  static const String GEN_BY_SERVER = "11";
  static const String GEN_BY_MOBILE = "22";

  static int genUuid(){
      String machineId = GEN_BY_MOBILE;
      var uuid = Uuid();
      int hashCode = uuid.v1().hashCode;
   
      if(hashCode < 0){
          hashCode = -hashCode;
      }
      
      var now =new DateTime.now();
      String dayTime = fillNum2Weight(now.month)  + fillNum2Weight(now.day);
      //print("dayTime = $dayTime");
      int value = int.tryParse(machineId + dayTime + sprintf("%010d", [hashCode]));
      return value;
  }

  static String fillNum2Weight(int value){
    if(value < 0){
      value = -value;
    }

    return (value >= 10)?"$value":"0$value"; 
  }
}