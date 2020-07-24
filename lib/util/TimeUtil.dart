class TimeUtil{

  // 取得当前毫秒时间
  static int getNowMilliseconds(){
    var date = DateTime.now();
    return date.millisecondsSinceEpoch;
  }
  
}//end class