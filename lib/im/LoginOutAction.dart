import 'package:imclient/core/Account.dart';
import 'package:imclient/core/IMClient.dart';
import 'package:imclient/im/Action.dart';
import 'package:imclient/model/Codec.dart';
import 'package:imclient/model/Login.dart';
import 'package:imclient/model/Msg.dart';

///
///退出登录
///
class LoginOutAction extends IMAction{
  LoginOutCallback _loginOutCallback;

  LoginOutAction(this._loginOutCallback);

  @override
  void handleMsg(Msg msg){
    LoginOutResp resp = new LoginOutResp();
    resp.decode(msg.data);

    _handleLoginOutResp(resp);
  }

  //注销登录响应
  void _handleLoginOutResp(LoginOutResp resp){
    if(resp.resultCode == Codec.RESULT_CODE_SUCCESS){
      Account.clearUserInfo();
      if(_loginOutCallback != null){
        _loginOutCallback.loginOutSuccess();
      }
    }else{
      if(_loginOutCallback != null){
        _loginOutCallback.loginOutError();
      }
    }
  }

}//end class