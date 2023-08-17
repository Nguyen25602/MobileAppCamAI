import 'package:cloudgo_mobileapp/utils/auth_crmservice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../object/Request.dart';

class RequestRepository with ChangeNotifier {
  final List<Request> _requests = [];
  late String _token;
  late String _name;
  late String _employeeId;
  RequestRepository._create();
  static RequestRepository create() {
    RequestRepository repository = RequestRepository._create();
    return repository;
  }

  List<Request> get requests => _requests;

  void clear() {
    _requests.clear();
  }

  Future updateUserInformation(
      String token, String name, String employeeId) async {
    _token = token;
    _name = name;
    _employeeId = employeeId;
    await _getData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    return getLeaving(_token, _employeeId);
  }

  Request convertJsonToRequest(Map<String, dynamic> json) {
    var request = Request.fromMap(data: json);
    request.name = _name;
    return request;
  }

  Future _getData() async {
    Map<String, dynamic> data;
    try {
      data = await _fetchData();
    } on Exception {
      data = {"success": '0', "data": []};
    }
    clear();
    for (var item in data['data']) {
      _requests.add(convertJsonToRequest(item));
    }
  }

  int countApproveRequest(int? month) {
    return _requests
        .where((element) =>
            (month == null || element.startDate.month == month) &&
            element.state == StateOFRequest.accept)
        .length;
  }

  Future sendRequest(Map<String, String> dataRequest) async {
    dataRequest["RequestAction"] = "AddLeaving";
    dataRequest["token"] = _token;
    dataRequest["employeeId"] = _employeeId;

    //change with function call api to send request, then call notifyListeners()
    addLeaving(_token, dataRequest).then((value) async {
      await _getData();
      notifyListeners();
    });
  }

  List<Request> approvedRequest() {
    return _requests
        .where((element) => element.state == StateOFRequest.accept)
        .toList();
  }
}
