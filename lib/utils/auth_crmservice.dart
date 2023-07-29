import 'dart:convert';
import 'package:http/http.dart' as http;

//Login Username
Future<Map<String, dynamic>?> loginUsernameEmployee(
    String username, String password) async {
  const String apiUrl =
      "http://192.168.1.28/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "LoginByUserName",
    "IsOpenId": 0,
    "Credentials": {
      "api_key": "",
      "username": username,
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

//Login Gmail
Future<Map<String, dynamic>?> loginGmailEmployee(
    String email, String password) async {
  const String apiUrl =
      "http://192.168.1.28/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "LoginByEmail",
    "IsOpenId": 0,
    "Credentials": {
      "api_key": "",
      "email": email,
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
      "http://192.168.1.28/onlinecrm/api/EmployeePortalApi.php";
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

//ChangeProfile bằng Token
Future<String?> changeProfileEmployee(
    String token, Map<String, dynamic> requestData) async {
  const String apiUrl =
      "http://192.168.1.28/onlinecrm/api/EmployeePortalApi.php";
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
    return data["success"];
  } else {
    print("Error calling the API. Status code: ${response.statusCode}");
    return null;
  }
}

//Check Token lấy User Current App
Future<Map<String, dynamic>?> checkToken(
    String token, String employeeId) async {
  const String apiUrl =
      "http://192.168.1.28/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "CheckToken",
    "token": token,
    "employeeId": employeeId
  };

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
  }
  if (response.statusCode == 404) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    print("Error calling the API. Status code: ${response.statusCode}");
    return null;
  }
}