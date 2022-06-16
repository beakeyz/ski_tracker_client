import 'dart:convert';
import 'dart:io';
import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  // Im just gonna trust this never changes. I know this is bad practise, but fuck you 🤡
  static const String BACKUP_BASE_URL = "10.0.2.2:4000";
  static String BASE_URL = "localhost:4000";

  static void verifyHost(Function callback) async {
    try {
      String new_val = SettingVars.getByName("Server hostname")?.setting;
      print("NEW" + new_val);
      print("BASE" + BASE_URL);

      if (new_val != BASE_URL) {
        checkHostForConnection(new_val, (worked) {
          if (worked) {
            print("worked");
            BASE_URL = new_val;
            App.hasServer = true;
            callback(true);
            return;
          }
          print("didnt work");
          BASE_URL = new_val;
          App.hasServer = false;
          callback(false);
        });
      } else {
        callback(true);
      }
    } catch (e) {
      print(e);
      App.hasServer = false;
      callback(false);
    }
  }

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

  static void checkUrlForConnection(String url, Function callback) async {
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
  }

  static void checkHostForConnection(String url, Function callback) async {
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
  }

  //TODO clean this ABSOLUTE SHITHEAP up, ty
  static void makeRequest(String path, bool check, String method, Function callback, Function? errCallback) async {
    if (check) {
      verifyHost((value) async {
        try {
          if (!value) {
            throw Exception("yikes");
          }
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
      });
    } else {
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
    }
  }

  static void postRequest(String path, bool https, Object? body, Map<String, String>? headers, Function callback, Function? errCallback) async {
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
  }
}
