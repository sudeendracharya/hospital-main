import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hospital/models/patient.dart';
import 'package:hospital/models/patient_data.dart';
import 'package:hospital/screens/log_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ApiCalls extends GetxController {
  String _token = '';
  RxBool isLoggedIn = false.obs;
  List<Patient> patientList = [].obs.cast<Patient>().toList();
  RxMap patient = {}.obs;
  String get token {
    return _token;
  }

  bool get isAuth {
    if (_token != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, String>> getHeaders(var token) async {
    print('getting token $token');

    if (token == '') {
      var token = await getToken();
      print('calling token $token');
      if (token == '') {
        Get.offAllNamed(LogInPage.routeName);
        return {};
      }
      return {
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': 'Token $token',
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      };
    } else {
      return {
        'Content-type': 'application/json; charset=utf-8',
        'Authorization': 'Token $token',
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
            "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      };
    }
  }

  Map<String, String> authHeaders() {
    return {
      'Content-type': 'application/json; charset=utf-8',
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          "true", // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
    };
  }

  Future<int> authenticate(String url, var body) async {
    var urlLink = Uri.parse(url);

    try {
      http.Response response = await http.post(
        urlLink,
        headers: authHeaders(),
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'Token', jsonEncode({'Key': responseData['key']}));
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> logIn(String url, var body) async {
    var urlLink = Uri.parse(url);

    try {
      http.Response response = await http.post(
        urlLink,
        headers: authHeaders(),
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'Token', jsonEncode({'Key': responseData['key']}));
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> getPatientList(String url) async {
    var urlLink = Uri.parse(url);
    try {
      var headers = await getHeaders(_token);
      log(headers.toString());
      http.Response response = await http.get(
        urlLink,
        headers: headers,
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }
      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        log(response.body);
        var responseData = jsonDecode(response.body);
        List<Patient> temp = [];
        for (var data in responseData) {
          temp.add(
            Patient(
              patientName: data['Patient_Name'],
              id: data['id'],
              visited: data['Visited'],
            ),
          );
        }

        patientList = temp;
      }

      return response.statusCode;
    } catch (e) {
      log(e.toString());
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<int> getPatientDetails(String url) async {
    var urlLink = Uri.parse(url);
    try {
      var headers = await getHeaders(_token);

      http.Response response = await http.get(
        urlLink,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        patient.value = responseData;
        // List<Patient> temp = [];
        // for (var data in responseData) {
        //   temp.add(
        //     Patient(
        //       patientName: data['Patient_Name'],
        //       id: data['id'],
        //       visited: data['Visited'],
        //     ),
        //   );
        // }

        // patientList = temp;
      }

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      return response.statusCode;
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    log('trying auto login');
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('Token') != true) {
      return false;
    } else {
      var extratedData = sharedPreferences.getString('Token');
      var data = jsonDecode(extratedData!);
      _token = data['Key'];
      isLoggedIn.value = true;
      log('returning value');
      return true;
    }
  }

  Future<String> getToken() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('Token') != true) {
      return '';
    } else {
      var extratedData = sharedPreferences.getString('Token');
      var data = jsonDecode(extratedData!);
      _token = data['Key'];
      isLoggedIn.value = true;
      return data['Key'];
    }
  }

  Future<Map<String, dynamic>> uploadFile(String url, var data, String token,
      var image, var name, var fileType) async {
    var urlLink = Uri.parse(url);

    Map<String, String> headers = {
      'Content-type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    try {
      http.MultipartRequest request = http.MultipartRequest('POST', urlLink);
      request.headers.addAll(headers);
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          image,
          filename: name,
          contentType: MediaType(
            data['Type'],
            data['Sub_Type'],
          ),
        ),
      );
      request.fields['sender'] = data['Sender_Id'].toString();

      var res = await request.send();

      if (res.statusCode == 200 || res.statusCode == 201) {
        var response = await http.Response.fromStream(res);

        var data = jsonDecode(response.body);

        return {
          'Status_Code': res.statusCode,
          'Body': data as Map<String, dynamic>
        };
      }

      return {'Status_Code': res.statusCode, 'Body': null};
    } catch (e) {
      // catchException(e);
      // EasyLoading.dismiss();
      rethrow;
    }
  }
}
