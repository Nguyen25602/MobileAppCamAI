import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> loginEmployee(
    String email, String password) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "Login",
    "IsOpenId": 0,
    "Credentials": {
      "api_key": "",
      "username": email,
      "password": password,
    },
    "comment":
        "IsOpenId: 0, Credentials: {username: \"\", password: \"\"} or IsOpenId: 1, Credentials: {api_key: \"\", email: \"\"}",
  };
  final http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Client": "Mobile"
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    print("Error calling the API. Status code: ${response.statusCode}");
    return null;
  }
}

//Logout bằng Token
Future<Map<String, dynamic>?> logoutEmployee(String token) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {"RequestAction": "Logout"};
  final http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
      "Client": "Mobile",
      "token": token
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    print("Error calling the API. Status code: ${response.statusCode}");
    return null;
  }
}
