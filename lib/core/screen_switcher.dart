import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ScreenSwitcher {
  static bool gotoScreen(BuildContext context, Widget screen, bool check) {
    if (check) {
      // make api call to check premission (fuck oauth) and set the flag variable to it
      bool flag = true;
      if (flag) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => screen));
        return true;
      }

      return false;
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => screen));
      return true;
    }
    return false;
  }
}
