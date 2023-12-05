import 'package:permission_handler/permission_handler.dart';
import 'package:skitracker_client/constants/colors.dart';
import 'package:skitracker_client/constants/main_screens.dart';
import 'package:skitracker_client/core/screen_switcher.dart';
import 'package:skitracker_client/main.dart';
import 'package:skitracker_client/screens/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int initialPage;
  const HomeScreen({Key? key, required this.initialPage}) : super(key: key);

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
    pageController = PageController(initialPage: widget.initialPage);
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
          controller: pageController,
          onPageChanged: changePageEvent,
          children: mainScreens,
          //physics: const NeverScrollableScrollPhysics(),
        ),
        appBar: AppBar(
          centerTitle: false,
          actions: [
            const SizedBox(
              width: 20,
            ),
            !App.hasServer
                ? InkWell(
                    onTap: () {
                      //TODO: What here?
                    },
                    child: const Icon(Icons.wifi_off_rounded, size: 25),
                  )
                : const SizedBox(),
            !App.hasLocationAlways
                ? InkWell(
                  onTap: () {
                      Permission.locationAlways.request().then((value) {
                        setState(() {
                          App.hasLocationAlways = value.isGranted;
                        });
                      });
                    },
                  child: const Icon(Icons.access_alarm_rounded, size: 25),
                ) : const SizedBox(),
            Flexible(child: Container()),
            InkWell(
              onTap: () {
                ScreenSwitcher.pushScreen(context, const SettingsScreen());
              },
              child: const Icon(Icons.settings_outlined, size: 35),
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
