import 'package:imclient/core/Account.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/im/Action.dart';
import 'package:imclient/model/Login.dart';
import 'package:imclient/model/Msg.dart';

//登录消息处理
class LoginAction extends IMAction{
  AuthCallback authCallback;
  
  LoginAction(this.authCallback);

  @override
  void handleMsg(Msg msg) {
    LoginResp loginResp = new LoginResp();
    loginResp.decode(msg.data);

    _handleLogin(loginResp);
  }

  @override
  bool needCallback(){
    return false;
  }

  void _handleLogin(LoginResp loginResp){
    if(loginResp == null)
      return;
    
    if(loginResp.resultCode == LoginResp.RESULT_CODE_SUCCESS){
      Account.setUserInfo(loginResp.token, 
                          loginResp.account, 
                          loginResp.uid , 
                          loginResp.avator , 
                          loginResp.name);

      if(authCallback != null){
        authCallback.onAuthSuccess(loginResp.token, loginResp.account, loginResp.uid);
      }
    }else{//登录失败
      if(authCallback != null){
        authCallback.onAuthError(loginResp.resultCode);
      }
    }
  }
}//end class