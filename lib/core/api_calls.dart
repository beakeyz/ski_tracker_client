import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  static const String BASE_URL = "10.0.2.2:4000";

  static void checkForConnection(Function callback) async {
    try {
      final result = await InternetAddress.lookup('gnu.org');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        callback(true);
      }
    } on SocketException catch (_) {
      print('not connected');
      callback(false);
    }
  }

  static void makeRequest(String path, bool https, String method, Function callback) async {
    try {
      switch (method) {
        case "Get":
        case "get":
          await http.get(Uri.http(BASE_URL, path)).then((res) => callback(res));
          break;
        case "Post":
        case "post":
          await http.post(Uri.http(BASE_URL, path)).then((res) => callback(res));
          break;
        case "Delete":
        case "delete":
          await http.delete(Uri.http(BASE_URL, path)).then((res) => callback(res));
          break;
        case "Head":
        case "head":
          await http.head(Uri.http(BASE_URL, path)).then((res) => callback(res));
          break;
        default:
          await http.get(Uri.http(BASE_URL, path)).then((res) => callback(res));
          print("btw, u didnt specify a valid method -_-");
      }
    } catch (e) {
      print("fuck");
      print(e.toString());
    }
  }

  static void postRequest(String path, bool https, Map<String, String> headers, Function callback) async {
    try {
      Map<String, String> _headers = headers;

      await http.post(Uri.http(BASE_URL, path), headers: _headers).then((res) => callback(res));
    } catch (e) {
      print("fuck");
      print(e.toString());
    }
  }
}
