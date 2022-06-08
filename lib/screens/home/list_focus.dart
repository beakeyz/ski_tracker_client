import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:dadjoke_client/widgets/list_entry.dart';
import 'package:flutter/material.dart';

class ListFocus extends StatefulWidget {
  ListEntry tag;
  ListFocus({Key? key, required this.tag}) : super(key: key);

  @override
  State<ListFocus> createState() => _ListFocusState();
}

class _ListFocusState extends State<ListFocus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BACKGROUND_COLOR,
        shadowColor: BTN_COLOR,
      ),
      floatingActionButton: Container(
        width: 75,
        height: 75,
        child: Button(
          callback: () {
            // TODO: delete from database

            // when deletion confirmation has been recieved,
            ScreenSwitcher.popScreen(context);
          },
          child: Icon(Icons.delete_outline_sharp, size: 35),
        ),
      ),
      body: Container(
        child: Center(child: const Text("something")),
      ),
    );
  }
}
