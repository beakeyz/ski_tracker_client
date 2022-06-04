import 'dart:io';

import 'package:dadjoke_client/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  static const String BASE_URL = "10.0.2.2:4000";

  static void makeRequest(String path, bool https, Function callback) async {
    try {
      await http.get(Uri.http(BASE_URL, path)).then((res) => callback(res));
    } catch (e) {
      print("fuck");
      print(e.toString());
    }
  }

  static void askForFlag() {
    ApiUtils.makeRequest("/", false, (res) => {App.greenFlag = true});
  }
}
