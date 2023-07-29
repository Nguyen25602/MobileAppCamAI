import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //Keys
  static String userLoggerInKey = "LOGGEDINKEY"; // Kiểm Tra Trạng Thái User Cũ
  static String userNameKey = "USERNAMEKEY"; // Username Current
  static String employeeIdKey = "EMPLOYEEKEY"; // ID Module CPEmployee Current
  static String accessTokenKey =
      "ACCESSTOKENKEY"; // AccessToken Module CPEmployee Current

  //Saving Data to SF
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggerInKey, isUserLoggedIn);
  }

  //Save USERNAME -> SF
  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  //Save TOKEN -> SF
  static Future<bool> saveAccessTokenSF(String accessToken) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(accessTokenKey, accessToken);
  }

  //Save EmployeeID -> SF
  static Future<bool> saveEmployeeIdSF(String employeeId) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(employeeIdKey, employeeId);
  }

  //Getting the data
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggerInKey);
  }

  // Getting employeeId -> current user
  static Future<String?> getEmployeeIdFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(employeeIdKey);
  }

  // Getting token -> current user
  static Future<String?> getTokenFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(accessTokenKey);
  }

  // Getting username -> current user
  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
