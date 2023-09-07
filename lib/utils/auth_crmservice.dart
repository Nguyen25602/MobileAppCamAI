//
//
//END
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

//Login Username
Future<Map<String, dynamic>?> loginUsernameEmployee(
    String username, String password) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
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
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
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

//ChangeProfile bằng Token
Future<String?> changeProfileEmployee(
    String token, Map<String, dynamic> requestData) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
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
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
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

//Get Data CheckLogin
Future<Map<String, dynamic>> getCheckLog(
    String token, String employeeId) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "GetCheckLog",
    "employeeId": employeeId,
    "token": token
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
    Map<String, dynamic> data = {"success": "1", "data": []};
    return data;
  }
}

//Add Data CheckLog
Future<Map<String, dynamic>> addCheckLog(
    String token, Map<String, dynamic> requestData) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";

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
    print(data);
    return data;
  }
  if (response.statusCode == 404) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    print("Error calling the API. Status code: ${response.statusCode}");

    return {"success": "0"};
  }
}

//Add Data CheckLogin
Future<Map<String, dynamic>> addCheckLogCameraDevice(
    String token, Map<String, dynamic> requestData, File image) async {
  final uri =
      Uri.parse("http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php");
  final request = http.MultipartRequest('POST', uri);
  // Thêm các trường dữ liệu vào form-data
  requestData.forEach((key, value) {
    request.fields[key] = value.toString();
  });
  // Thêm tệp hình ảnh vào form-data (nếu có)
  if (image != null) {
    final imageField =
        await http.MultipartFile.fromPath('fileToUpload', image.path);
    request.files.add(imageField);
  }
  // Thêm các headers
  request.headers.addAll({
    "Content-Type": "application/json; charset=UTF-8",
    "Client": "Mobile",
    "token": token,
  });
  // Gửi yêu cầu và nhận phản hồi
  final response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    return data;
  }
  if (response.statusCode == 404) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    print("Error calling the API. Status code: ${response.statusCode}");

    return {"success": "0"};
  }
}

// Hoang Nguyen
// SaveFCMToken -> Push Notification
// 12/08/2023
Future<Map<String, dynamic>?> saveFcmToken(
    String token, Map<String, dynamic> requestData) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";

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
    print(data);
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

//Get Notification
//Get Data CheckLogin
Future<Map<String, dynamic>> getNotificationList(
    String token, String employeeId, int? offset) async {
  if (offset == null) {
    return {
      "success": "1",
      "entry_list": [],
      "unread_count": "0",
      "paging": {"next_offset": ""}
    };
  }
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "GetNotificationList",
    "employeeId": employeeId,
    "Params": {
      "paging": {"offset": offset}
    }
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
    Map<String, dynamic> data = {
      "success": "1",
      "entry_list": [],
      "unread_count": "0",
      "paging": {"next_offset": ""}
    };
    return data;
  }
}

//Get Data CheckLogin
Future<Map<String, dynamic>> markNotificationsAsRead(
    String token, String employeeId, int id) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "MarkNotificationsAsRead",
    "employeeId": employeeId,
    "Params": {"target": id},
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
    Map<String, dynamic> data = {
      "success": "0",
    };
    return data;
  }
}

// Function Handle CPLeaving Mobile App -> CRM
// Create 15/8/2023
// Get Leaving by employeeID
Future<Map<String, dynamic>> getLeaving(String token, String employeeId) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";
  final Map<String, dynamic> requestData = {
    "RequestAction": "GetLeavingEmployee",
    "employeeId": employeeId,
    "token": token
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
    Map<String, dynamic> data = {"success": "0", "data": []};
    return data;
  }
}

// Add Leaving
Future<Map<String, dynamic>?> addLeaving(
    String token, Map<String, dynamic> requestData) async {
  const String apiUrl =
      "http://192.168.31.33/onlinecrm/api/EmployeePortalApi.php";

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
    print(data);
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
