import 'dart:io';

class NetClient{
  static NetClient instance;

  static NetClient getInstance(){
    if(instance == null){
      instance = new NetClient();
    }

    return instance;
  }


  void init(){
    print("im netclient init");
  }

  void dispose(){
    print("im netclient dispose");
  }
  
}//end class
