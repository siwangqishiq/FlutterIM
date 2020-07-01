import 'package:imclient/config.dart';

enum Env{
  REAL, 
  DEV
}

class ServerConfig{
  Env env;

  String imServer;
  int imPort;

  static ServerConfig instance = new ServerConfig(Env.DEV);

  ServerConfig(Env e){
    this.env = e;

    if(env == Env.REAL){ //真实环境
      imServer = IM_SERVER_HOST;
      imPort = IM_SERVER_PORT;
    }else{ //测试环境
      imServer = IM_SERVER_HOST;
      imPort = IM_SERVER_PORT;
    }
  }
}//end class