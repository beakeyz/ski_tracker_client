import 'dart:convert';
import 'dart:io';
import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'StateLock.dart';

class ApiUtils {
  // Im just gonna trust this never changes. I know this is bad practise, but fuck you 🤡
  static const String BACKUP_BASE_URL = "10.0.2.2:4000";
  static String BASE_URL = "localhost:4000";

  static StateLock lock = StateLock();

  static void verifyHost(Function callback) async {
    try {
      Setting? setting = SettingVars.getByName("Server hostname");
      if (setting != null && setting is StringSetting) {
        String new_val = setting.value;
        print("NEW" + new_val);
        print("BASE" + BASE_URL);

        checkHostForConnection(new_val, (worked) {
          if (worked) {
            print("worked");
            App.hasServer = true;
            callback(true);
            return;
          }
          print("didnt work");
          App.hasServer = false;
          callback(false);
        });
      }
      
    } catch (e) {
      print(e);
      App.hasServer = false;
      callback(false);
    }
  }

  static void setHost(String host) {
    BASE_URL = host;
  }

  static void checkUrlForConnection(String url, Function callback) async {
    if (!lock.aquireStateLock()) return;

    try {
      final result = await InternetAddress.lookup(url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        callback(true);
      } 
    } on SocketException catch (_) {
      print('not connected');
      callback(false);
    }
    lock.releaseStateLock();
  }

  
  static void checkForConnection(Function callback) {
    checkUrlForConnection("gnu.org", callback);
  }

  static void checkHostForConnection(String url, Function callback) async {
    if (!lock.aquireStateLock()) return;
    //TODO
    try {
      await http.get(Uri.http(url, "/")).then((result) {
        callback(true);
      });
    } catch (e) {
      print('not connected');
      print(e);
      callback(false);
    }
    lock.releaseStateLock();
  }

  //TODO clean this ABSOLUTE SHITHEAP up, ty
  static void makeRequest(String path, String method, Function callback, Function? errCallback) async {
    if (!lock.aquireStateLock()) return;
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
      errCallback?.call();
    }
    lock.releaseStateLock();
  }

  static void postRequest(String path, bool https, Object? body, Map<String, String>? headers, Function callback, Function? errCallback) async {
    if (!lock.aquireStateLock()) return;
    verifyHost((value) async {
      try {
        if (!value) {
          throw Exception("yikes");
        }
        // Just to be clear on what elements we are using in the post constructor
        Map<String, String>? _headers = headers;
        Object? _body = body;

        await http.post(Uri.http(BASE_URL, path), body: _body, headers: _headers).then((res) => callback(res));
      } catch (e) {
        print("fuck");
        print(e.toString());
        errCallback?.call();
      }
    });
    lock.releaseStateLock();
  }
}
