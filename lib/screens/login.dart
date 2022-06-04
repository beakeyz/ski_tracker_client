import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 55),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //things

              Flexible(
                child: Container(),
                flex: 2,
              ),

              SvgPicture.asset(
                "assets/mysql-icon.svg",
                color: PRIMARY_COLOR,
                height: 100,
              ),
              const SizedBox(height: 71),

              Button(
                callback: () {
                  if (ScreenSwitcher.gotoScreen(
                          context, const HomeScreen(), true) ==
                      false) {}
                },
                text: "Get going!",
              ),

              Flexible(
                child: Container(),
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
