const String IM_SERVER_HOST = "10.219.32.66";
const int IM_SERVER_PORT = 1998;

enum Env{
  REAL, 
  DEV
}

class ServerConfig{
  Env env;

  String IM_Server;
  int IM_Port;

  static ServerConfig instance = new ServerConfig(Env.DEV);

  ServerConfig(Env e){
    this.env = e;

    if(env == Env.REAL){ //真实环境
      IM_Server = IM_SERVER_HOST;
      IM_Port = IM_SERVER_PORT;
    }else{ //测试环境
      IM_Server = IM_SERVER_HOST;
      IM_Port = IM_SERVER_PORT;
    }
  }
}//end class

