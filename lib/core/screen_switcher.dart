import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ScreenSwitcher {
  static void gotoScreen(
    BuildContext context,
    Widget screen,
    bool check,
  ) {
    if (check) {
      // make api call to check premission (fuck oauth) and set the flag variable to it
      ApiUtils.makeRequest("/", false, (res) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => screen));
        App.greenFlag = true;
      });
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  static bool pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
    return true;
  }
}
