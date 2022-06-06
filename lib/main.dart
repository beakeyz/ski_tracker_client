import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  ApiUtils.checkForConnection((has) {
    bool _has = has;
    print(_has);
    runApp(
      Main(
        has_internet: _has,
      ),
    );
  });
}

class App {
  static bool hasServer = true;
}

class Main extends StatelessWidget {
  final bool has_internet;
  const Main({Key? key, required this.has_internet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dadjokegen client",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: BACKGROUND_COLOR),
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
