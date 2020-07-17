import 'package:shared_preferences/shared_preferences.dart';
import 'package:imclient/util/TextUtil.dart';

//当前账户
class Account {
  static const String _KEY_TOKEN = "token";
  static const String _KEY_ACCOUNT = "account";
  static const String _KEY_UID = "_uid";
  static const String _KEY_AVATOR = "_avator";
  static const String _KEY_NAME = "_name";
  static const String _KEY_DESC = "_desc";
  static const String _KEY_SEX = "_sex";
  static const String _KEY_AGE = "_age";

  static String _token;
  static String _account;
  static int _uid;
  static String _avator;
  static String name;
  static int sex;
  static String desc;
  static int age;

  //
  static Future loadAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_KEY_TOKEN);
    _account = prefs.getString(_KEY_ACCOUNT);
    _uid = prefs.getInt(_KEY_UID);
    _avator = prefs.getString(_KEY_AVATOR);
    name = prefs.getString(_KEY_NAME);
    sex = prefs.getInt(_KEY_SEX);
    desc = prefs.getString(_KEY_DESC);
    age = prefs.getInt(_KEY_AGE);
  }

  static void setUserInfo(String token , String account , int uid , String avator , String displayName , 
  int male , String description , int _age) async {
    _token = token;
    _account = account;
    _uid = uid;
    _avator = avator;
    name = displayName;
    sex = male;
    desc = description;
    age = _age;
    _infoDao();
  }

  static void clearUserInfo() async{
    _token = null;
    _account = null;
    _uid = 0;
    _avator = null;
    name = null;
    sex = 1;
    desc = null;
    age = 0;

    _infoDao();
  }

  static void _infoDao() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_KEY_TOKEN, _token);
    prefs.setString(_KEY_ACCOUNT, _account);
    prefs.setInt(_KEY_UID, _uid);
    prefs.setString(_KEY_AVATOR, _avator);
    prefs.setString(_KEY_NAME, name);
    prefs.setInt(_KEY_SEX, sex);
    prefs.setString(_KEY_DESC, desc);
    prefs.setInt(_KEY_AGE, age);
  }

  static String getToken(){
    return _token;
  }

  static int getUid(){
    return _uid;
  }

  static String getAvator(){
    return _avator;
  }

  //是否登录
  static bool isLogin(){
    return !TextUtil.isEmpty(_account) && !TextUtil.isEmpty(_token);
  }

}//end class
