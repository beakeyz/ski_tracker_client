import 'dart:io';
import 'package:skitracker_client/core/models/Settings.dart';
import 'package:skitracker_client/main.dart';
import 'package:http/http.dart' as http;

class ApiUtils {
  // Im just gonna trust this never changes. I know this is bad practise, but fuck you 🤡
  static const String BACKUP_BASE_URL = "10.0.2.2:4000";
  static String BASE_URL = "localhost:4000";

  static void verifyHost(Function callback) async {
    try {
      Setting? setting = SettingVars.getByName("Server hostname");
      if (setting != null && setting is StringSetting) {
        String newVal = setting.value;

        checkHostForConnection(newVal, (worked) {
          if (worked) {
            App.hasServer = true;
            callback(true);
            return;
          }
          App.hasServer = false;
          callback(false);
        });
      }
      
    } catch (e) {
      App.hasServer = false;
      callback(false);
    }
  }

  static void setHost(String host) {
    BASE_URL = host;
  }

  static void checkUrlForConnection(String url, Function callback) async {
    
    try {
      final result = await InternetAddress.lookup(url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        callback(true);
      } 
    } on SocketException catch (_) {
      callback(false);
    }
  }

  
  static void checkForConnection(Function callback) {
    checkUrlForConnection("gnu.org", callback);
  }

  static void checkHostForConnection(String url, Function callback) async {
    //TODO
    try {
      await http.get(Uri.http(url, "/")).then((result) {
        callback(true);
      });
    } catch (e) {
      callback(false);
    }
  }

  //TODO clean this ABSOLUTE SHITHEAP up, ty
  static void makeRequest(String path, String method, Function callback, Function? errCallback) async {
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
      }
      return;
    } catch (e) {
      errCallback?.call();
    }
    errCallback?.call();
  }

  static void postRequest(String path, bool https, Object? body, Map<String, String>? headers, Function callback, Function? errCallback) async {
    verifyHost((value) async {
      try {
        if (!value) {
          throw Exception("yikes");
        }
        // Just to be clear on what elements we are using in the post constructor
        Map<String, String>? headers0 = headers;
        Object? body0 = body;

        await http.post(Uri.http(BASE_URL, path), body: body0, headers: headers0).then((res) => callback(res));
      } catch (e) {
        errCallback?.call();
      }
    });
  }
}
