import 'dart:io';

import 'package:dadjoke_client/constants/api_endpoints.dart';
import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/LocalStorage.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/main.dart';
import 'package:dadjoke_client/screens/about.dart';
import 'package:dadjoke_client/screens/home.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool is_waiting = false;

  void updateWaiting(bool new_val) {
    setState(() {
      is_waiting = new_val;
    });
  }

  void noConnection() {
    App.hasServer = false;
    LocalStorage().checkFile(LocalStorage.PATH, false, (file) {
      //
      if (file != null) {
        LocalStorage().initStorage();
        print("storage done!");
      }
      updateWaiting(false);
      ScreenSwitcher.gotoScreen(context, const HomeScreen(), false);
    });
  }

  void handleBtnClick() {
    updateWaiting(true);

    ApiUtils.checkUrlForConnection(ApiUtils.BASE_URL, (conectionExists) {
      if (conectionExists) {
        ApiUtils.makeRequest(TEST_API, "get", (res) {
          App.hasServer = true;
          updateWaiting(false);
          ScreenSwitcher.gotoScreen(context, const HomeScreen(), false);
        }, () {
          noConnection();
        });
      } else {
        noConnection();
      }
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
                colors: [
                  Color.fromARGB(255, 79, 44, 60),
                  Color.fromARGB(186, 21, 20, 20),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //things
                Flexible(
                  child: Container(),
                  flex: 2,
                ),

                SvgPicture.asset(
                  "assets/dadjoke-icon.svg",
                  color: PRIMARY_COLOR,
                  height: 200,
                ),
                const SizedBox(height: 71),

                Button(
                  callback: () {
                    handleBtnClick();
                  },
                  child: !is_waiting
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
                        if (!is_waiting) {
                          ScreenSwitcher.pushScreen(context, const AboutPage());
                        }
                      },
                      child: const SizedBox(
                        width: 200,
                        height: 25,
                        child: Center(child: Text("About this app", style: TextStyle(fontSize: 23, decoration: TextDecoration.underline))),
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
