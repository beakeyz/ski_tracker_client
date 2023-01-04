import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:dadjoke_client/widgets/list_entry.dart';
import 'package:flutter/cupertino.dart';
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
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: BACKGROUND_COLOR,
          boxShadow: [
            BoxShadow(blurRadius: 16, spreadRadius: 16, color: BLUR_COLOR, offset: Offset(0, 12)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              widget.tag.Joke.Date,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Flexible(child: Container()),
            Container(
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
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  child: Text(
                    widget.tag.Joke.Summary,
                    style: const TextStyle(
                      fontSize: 32,
                      overflow: TextOverflow.clip,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 7, 7, 7),
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.tag.Joke.joke,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
