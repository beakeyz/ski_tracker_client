import 'dart:convert';

import 'package:dadjoke_client/constants/api_endpoints.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/DataEntry.dart';
import 'package:dadjoke_client/core/models/LocalStorage.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/main.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:dadjoke_client/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String responseText = "Send";

  void setResponseText(String new_string) {
    if (new_string.isEmpty) {
      setState(() {
        responseText = "Send";
      });
      return;
    }
    setState(() {
      responseText = new_string;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    summaryController.dispose();
  }

  void processInputToServer() {
    String summary = summaryController.text;
    String joke = contentController.text;
    String time = DateUtils.dateOnly(DateTime.now()).toString().split(" ")[0];
    print(time);
    // We are NOT going to trust the client about what the index is, so this will be a funny number =)
    // We ARE going to trust the user with the strings it sends (for now)
    DataEntry entry = DataEntry(Summary: summary, joke: joke, Date: time, index: 69);
    var header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    ApiUtils.postRequest(POST_JOKES, false, jsonEncode(entry.toJson()), header, (res) {
      // DEBUG
      Response r = res;
      print(r.headers);

      // thing
      setResponseText(r.body);
      if (r.body.contains("Success")) {
        setState(() {
          summaryController.text = "";
          contentController.text = "";
        });
      }
    }, () {
      setResponseText("Could not connect!");
    });
  }

  void processInputLocally() {
    String summary = summaryController.text;
    String joke = contentController.text;
    String time = DateUtils.dateOnly(DateTime.now()).toString().split(" ")[0];

    // We are NOT going to trust the client about what the index is, so this will be a funny number =)
    // We ARE going to trust the user with the strings it sends (for now)
    DataEntry entry = DataEntry(Summary: summary, joke: joke, Date: time, index: 69);
    LocalStorage().saveToStorage(entry, () {
      setState(() {
          summaryController.text = "";
          contentController.text = "";
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              const Text(
                "Input",
                textScaleFactor: 4,
              ),
              const SizedBox(height: 50),
              TextInputField(editingController: summaryController, hintText: "Brief description   💫", textInputType: TextInputType.text, boxWidth: 290),
              const SizedBox(
                height: 10,
              ),
              TextInputField(editingController: contentController, hintText: "Content   💫", textInputType: TextInputType.text),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Button(
                callback: () {
                  if (App.hasServer) {
                    processInputToServer();
                  } else {
                    processInputLocally();
                  }
                },
                child: Text(responseText),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
