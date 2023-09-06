import 'dart:convert';
import 'dart:io';

import 'package:gudsman_service/main.dart';
import 'package:gudsman_service/utils/exceptions/unauthorized_exception.dart';
import 'package:gudsman_service/utils/shared_prefs.dart';
import 'package:gudsman_service/utils/urls.dart';
import 'package:http/http.dart' as http;

class HttpReq {
  final response = http.Response;

  static Future<http.Response> get(
      {String path = '',
      Map<String, String> headers = const {},
      bool authorized = false}) async {
    final String accessToken =
        await SharedPref.getAccessToken().then((value) => value);
    if (accessToken == '') {
      navigatorKey.currentState!.pushReplacementNamed('/login');
      // throw UnauthorizedException(cause: 'No Token Found');
    }
    final response = await http.get(Uri.parse(baseURL + path), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authorized ? accessToken : ''}',
      ...headers
    });

    if (response.statusCode == 401) {
      SharedPref.setPrefsData('accessToken', '');
      navigatorKey.currentState!.pushReplacementNamed('/login');
    }

    return response;
  }

  static Future<http.Response> post(
      String path, Map<String, dynamic> body, Map<String, String> headers,
      {bool authorized = false, context}) async {
    final String accessToken =
        await SharedPref.getAccessToken().then((value) => value);
    if (accessToken == '') {
      throw UnauthorizedException();
    }
    final response = await http
        .post(Uri.parse(baseURL + path), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authorized ? accessToken : ''}',
      ...headers
    });

    if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    }

    return response;
  }

  static Future<http.Response> put(
      {path = '',
      body = const {},
      headers = const {},
      authorized = true}) async {
    final String accessToken =
        await SharedPref.getAccessToken().then((value) => value);
    if (accessToken == '') {
      navigatorKey.currentState!.pushReplacementNamed('/login');
      // throw UnauthorizedException(cause: 'No Token Found');
    }

    final response = await http
        .put(Uri.parse(baseURL + path), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${authorized ? accessToken : ''}',
    });

    if (response.statusCode == 401) {
      navigatorKey.currentState!.pushReplacementNamed('/login');
    }

    return response;
  }
}

class FileModel {
  FileModel({required this.fieldName, required this.imagePath});
  final String fieldName;
  final String imagePath;

  Future<http.MultipartFile> convert() async {
    return http.MultipartFile.fromPath('', imagePath);
  }
}

class HttpMultiPartReq {
  static Future<http.StreamedResponse> multipart(
      {method = 'post',
      path = '',
      Map<String, dynamic> body = const {}}) async {
    final String accessToken = await SharedPref.getAccessToken();

    final request = http.MultipartRequest(
        method.toString().toUpperCase(), Uri.parse(baseURL + path));

    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
    };
    request.headers.addAll(headers);

    body.forEach((sectionTitle, sectionValue) {
      sectionValue.forEach((key, value) {
        print(value.runtimeType);
        if (value.runtimeType == String) {
          request.fields.addAll({key: value});
        } else {
          print('file exists');
          final uploadFile = File(value['value']);
          request.files.add(http.MultipartFile(
            key,
            uploadFile.readAsBytes().asStream(),
            uploadFile.lengthSync(),
            filename: key,
          ));
        }
      });
    });

    print(request.fields);
    final response = await request.send();

    return response;
  }
}

class AuthHttpRequest {
  static Future<http.Response> login(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseURL/login'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    if (response.statusCode == 200) {
      SharedPref.setPrefsData(
          'accessToken', json.decode(response.body)['token']);
    }

    return response;
  }

  static Future<http.Response> signup(Map<String, String> body) async {
    final response = await http.post(Uri.parse('$baseURL/signup'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    if (response.statusCode == 201) {
      // this is the success code
      // Sends an email to be verified by the User
    }

    return response;
  }
}
