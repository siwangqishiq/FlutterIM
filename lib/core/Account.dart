import 'package:shared_preferences/shared_preferences.dart';
import 'package:imclient/util/TextUtil.dart';

//当前账户
class Account {
  static const String _KEY_TOKEN = "token";
  static const String _KEY_ACCOUNT = "account";
  static const String _KEY_UID = "_uid";

  static String _token;
  static String _account;
  static int _uid;

  //
  static Future loadAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_KEY_TOKEN);
    _account = prefs.getString(_KEY_ACCOUNT);
    _uid = prefs.getInt(_KEY_UID);

    print("token : $_token");
    print("account : $_account");
    print("uid : $_uid");
  }

  static void setUserInfo(String token , String account , int uid) async {
    _token = token;
    _account = account;
    _uid = uid;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_TOKEN, _token);
    prefs.setString(_KEY_ACCOUNT, _account);
    prefs.setInt(_KEY_UID, _uid);
  }

  String getToken(){
    return _token;
  }

  int getUid(){
    return _uid;
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
