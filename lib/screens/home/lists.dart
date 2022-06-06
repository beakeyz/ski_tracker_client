import 'dart:convert';

import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/JokeEntry.dart';
import 'package:dadjoke_client/core/models/JokeList.dart';
import 'package:dadjoke_client/main.dart';
import 'package:dadjoke_client/widgets/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  JokeList? _entries = null;
  bool no_internet = false;

  @override
  void initState() {
    super.initState();
    print("loading the lists...");

    if (App.hasServer) {
      ApiUtils.makeRequest("/getJokes", false, "get", (res) {
        // Api method

        Response _res = res;
        print(_res.body);
        var jokes = jsonDecode(_res.body);
        JokeList dummy = JokeList.fromJson(jokes);
        print(dummy.size);
        if (dummy.size == _entries?.size) {
          return;
        }
        setState(() {
          _entries = dummy;
        });
      }, () {});
    } else {
      setState(() {
        no_internet = true;
      });
    }
    // TODO: file-to-server synchronization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              no_internet
                  ? Flexible(
                      child: Container(),
                      flex: 2,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              !no_internet
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _entries == null ? 0 : _entries!.size,
                        itemBuilder: ((context, index) {
                          return ListEntry(
                            Joke: _entries!.list[index].joke,
                          );
                        }),
                      ),
                    )
                  : Text(
                      "TODO: load local cache",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: PRIMARY_COLOR,
                            offset: Offset(4, 6),
                          )
                        ],
                      ),
                    ),
              no_internet
                  ? Flexible(
                      child: Container(),
                      flex: 2,
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}