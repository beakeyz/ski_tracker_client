import 'dart:io';

import 'package:skitracker_client/constants/api_endpoints.dart';
import 'package:skitracker_client/constants/colors.dart';
import 'package:skitracker_client/core/api_calls.dart';
import 'package:skitracker_client/core/models/LocalStorage.dart';
import 'package:skitracker_client/core/res/DataFetcher.dart';
import 'package:skitracker_client/core/screen_switcher.dart';
import 'package:skitracker_client/main.dart';
import 'package:skitracker_client/screens/about.dart';
import 'package:skitracker_client/screens/home.dart';
import 'package:skitracker_client/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isWaiting = false;

  void updateWaiting(bool new_val) {
    setState(() {
      isWaiting = new_val;
    });
  }

  void noConnection() {
    App.hasServer = false;
    LocalStorage().checkFile(LocalStorage.PATH, false, (file) {
      //
      if (file != null) {
        LocalStorage().initStorage();
      }
      updateWaiting(false);
      ScreenSwitcher.gotoScreen(context, const HomeScreen(initialPage: 0), false);
    });
  }

  void handleBtnClick() {
    updateWaiting(true);

    DataFetcher.getPhysicalDevicePosition().then((pos) {
      ApiUtils.checkUrlForConnection(ApiUtils.BASE_URL, (conectionExists) {
        if (!conectionExists) {
          noConnection();
          return;
        }

        /* Make a test request to our API to see if it's online */
        ApiUtils.makeRequest(TEST_API, "get", (res) {
          App.hasServer = true;
          updateWaiting(false);
          ScreenSwitcher.gotoScreen(context, const HomeScreen(initialPage: 0), false);
        }, () {
          /* Nope, go into offline mode */
          noConnection();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 55),
            width: double.infinity,
            color: PRIMARY_COLOR,
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //things
                Flexible(
                  flex: 2,
                  child: Container(),
                ),

                SvgPicture.asset(
                  "assets/skitracker-icon.svg",
                  height: 200,
                ),
                const SizedBox(height: 71),

                Button(
                  callback: () {
                    handleBtnClick();
                  },
                  child: !isWaiting
                      ? const Text(
                          "Get going!",
                        )
                      : const CircularProgressIndicator(
                          color: PRIMARY_COLOR,
                          strokeWidth: 1.5,
                        ),
                ),
                
                
                Flexible(
                  flex: 3,
                  child: Container(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Container()),
                    InkWell(
                      onTap: () {
                        if (!isWaiting) {
                          ScreenSwitcher.pushScreen(context, const AboutPage());
                        }
                      },
                      child: const SizedBox(
                        width: 200,
                        height: 25,
                        child: Center(
                          child: Text(
                            "About this app",
                             style: TextStyle(
                              fontSize: 23,
                              decoration: TextDecoration.underline,
                              color: SECONDARY_COLOR
                            ), 
                          )
                        ),
                      ),
                    ),
                    Flexible(child: Container())
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
