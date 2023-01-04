
import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class DefaultPageAppbar extends StatefulWidget {
  final Widget child;
  final Widget? extraEntriesBeforeFlex;
  const DefaultPageAppbar({super.key, required this.child, this.extraEntriesBeforeFlex});

  @override
  State<DefaultPageAppbar> createState() => _DefaultPageAppbarState();
}

class _DefaultPageAppbarState extends State<DefaultPageAppbar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                ScreenSwitcher.popScreen(context);
              },
              child: const Icon(Icons.arrow_back_ios_new, size: 25),
            ),
            widget.extraEntriesBeforeFlex ?? Container(),
            Flexible(
              flex: 1,
              child: Container(),
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
        body: widget.child,
    );
  }
}