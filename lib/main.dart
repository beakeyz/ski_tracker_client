import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dadjokegen client",
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: BACKGROUND_COLOR),
      home: const Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
