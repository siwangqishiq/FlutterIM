import 'package:shared_preferences/shared_preferences.dart';
import 'package:imclient/util/TextUtil.dart';

//当前账户
class Account {
  static const String _KEY_TOKEN = "token";
  static const String _KEY_ACCOUNT = "account";

  static String _token;
  static String _account;

  //
  static Future loadAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_KEY_TOKEN);
    _account = prefs.getString(_KEY_ACCOUNT);
  }

  //是否登录
  static bool isLogin(){
    return !TextUtil.isEmpty(_account) && !TextUtil.isEmpty(_token);
  }

  static void saveConfig(String key , String value){
    if(isLogin()){

    }
  }

  static String readConfig(String key){
    return null;
  }

}//end class
