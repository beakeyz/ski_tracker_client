import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/constants/main_screens.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _slide = 0;
  late PageController pageController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void jmpPage(int page) {
    pageController.jumpToPage(page);
  }

  void changePageEvent(int page) {
    setState(() {
      _slide = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: PageView(
          children: main_screens,
          controller: pageController,
          onPageChanged: changePageEvent,
          //physics: const NeverScrollableScrollPhysics(),
        ),
        appBar: AppBar(
          centerTitle: false,
          actions: [
            InkWell(
              onTap: () {
                ScreenSwitcher.pushScreen(context, const SettingsScreen());
              },
              child: const Icon(Icons.layers_outlined, size: 35),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
          shape: const Border(
            bottom: BorderSide(
              color: SECONDARY_COLOR,
              width: 2,
            ),
          ),
          shadowColor: SECONDARY_COLOR,
          backgroundColor: BACKGROUND_COLOR,
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _slide == 0 ? PRIMARY_COLOR : SECONDARY_COLOR,
                shadows: const [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              label: '',
              backgroundColor: SECONDARY_COLOR,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: _slide == 1 ? PRIMARY_COLOR : SECONDARY_COLOR,
                shadows: const [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              label: '',
              backgroundColor: SECONDARY_COLOR,
            ),
          ],
          iconSize: 40,
          height: 45,
          border: const Border(
            top: BorderSide(
              color: SECONDARY_COLOR,
              width: 2,
            ),
          ),
          backgroundColor: BACKGROUND_COLOR,
          activeColor: PRIMARY_COLOR,
          onTap: jmpPage,
        ),
      ),
    );
  }
}
