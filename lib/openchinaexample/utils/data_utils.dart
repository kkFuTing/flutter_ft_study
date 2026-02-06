import 'package:flutter_ft_study/openchinaexample/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataUtils {
  static const String SP_ACCESS_TOKEN = 'access_token';
  static const String SP_REFRESH_TOKEN = 'refresh_token';
  static const String SP_UID = 'uid';
  static const String SP_TOKEN_TYPE = 'token_type';
  static const String SP_EXPIRES_IN = 'expires_in';
  static const String IS_LOGIN = 'is_login';

  //用户信息字段
  static const String SP_USER_GENDER = 'gender';
  static const String SP_USER_NAME = 'name';
  static const String SP_USER_LOCATION = 'location';
  static const String SP_USER_ID = 'id';
  static const String SP_USER_AVATAR = 'avatar';
  static const String SP_USER_EMAIL = 'email';
  static const String SP_USER_URL = 'url';
  static Future<void> saveLoginInfo(Map<String, dynamic> loginInfo) async {
    if (loginInfo != null && loginInfo.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs
        ..setString(SP_ACCESS_TOKEN, loginInfo[SP_ACCESS_TOKEN])
        ..setString(SP_REFRESH_TOKEN, loginInfo[SP_REFRESH_TOKEN])
        ..setInt(SP_UID, loginInfo[SP_UID])
        ..setString(SP_TOKEN_TYPE, loginInfo[SP_TOKEN_TYPE])
        ..setString(SP_EXPIRES_IN, loginInfo[SP_EXPIRES_IN])
        ..setBool(IS_LOGIN, true);
    }
  }

  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..setBool(IS_LOGIN, false)
      ..setString(SP_ACCESS_TOKEN, '')
      ..setString(SP_REFRESH_TOKEN, '')
      ..setInt(SP_UID, -1)
      ..setString(SP_TOKEN_TYPE, '')
      ..setString(SP_EXPIRES_IN, '')
      ..setBool(IS_LOGIN, false);
  }

  //是否登录
  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_LOGIN) ?? false;
  }

  //获取token信息
  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool(IS_LOGIN) ?? false;
    if (isLogin) {
      return prefs.getString(SP_ACCESS_TOKEN) ?? '';
    }
    return '';
  }

  //获取refreshToken
  static Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SP_REFRESH_TOKEN) ?? '';
  }

  //获取用户信息
  static Future<User?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return User(
      gender: prefs.getString(SP_USER_GENDER) ?? '',
      name: prefs.getString(SP_USER_NAME) ?? '',
      location: prefs.getString(SP_USER_LOCATION) ?? '',
      id: prefs.getInt(SP_USER_ID) ?? 0,
      avatar: prefs.getString(SP_USER_AVATAR) ?? '',
      email: prefs.getString(SP_USER_EMAIL) ?? '',
      url: prefs.getString(SP_USER_URL) ?? '',
    );
  }

  //保存用户信息
  static Future<User?> saveUserInfo(Map<String, dynamic> userInfo) async {
    if (userInfo.isEmpty) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..setInt(SP_USER_ID, userInfo[SP_USER_ID])
      ..setString(SP_USER_GENDER, userInfo[SP_USER_GENDER])
      ..setString(SP_USER_NAME, userInfo[SP_USER_NAME])
      ..setString(SP_USER_LOCATION, userInfo[SP_USER_LOCATION])
      ..setString(SP_USER_AVATAR, userInfo[SP_USER_AVATAR])
      ..setString(SP_USER_EMAIL, userInfo[SP_USER_EMAIL])
      ..setString(SP_USER_URL, userInfo[SP_USER_URL]);

    User user = User(
      id: userInfo[SP_USER_ID] ?? 0,
      gender: userInfo[SP_USER_GENDER] ?? '',
      name: userInfo[SP_USER_NAME] ?? '',
      location: userInfo[SP_USER_LOCATION] ?? '',
      avatar: userInfo[SP_USER_AVATAR] ?? '',
      email: userInfo[SP_USER_EMAIL] ?? '',
      url: userInfo[SP_USER_URL] ?? '',
    );
    return user;
  }
}
