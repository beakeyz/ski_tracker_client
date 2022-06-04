import 'package:dadjoke_client/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("success!"),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            backgroundColor: PRIMARY_COLOR,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
            backgroundColor: PRIMARY_COLOR,
          ),
        ],
        backgroundColor: BACKGROUND_COLOR,
      ),
    );
  }
}
