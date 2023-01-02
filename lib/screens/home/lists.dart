import 'dart:convert';

import 'package:dadjoke_client/constants/api_endpoints.dart';
import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/DataEntry.dart';
import 'package:dadjoke_client/core/models/DataList.dart';
import 'package:dadjoke_client/core/models/LocalStorage.dart';
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
  DataList? _entries = null;
  bool no_internet = false;

  void setInternet(bool internet) {
    setState(() {
      no_internet = internet;
    });
  }

  @override
  void initState() {
    super.initState();
    print("loading the lists...");
    if (App.hasServer) {
      ApiUtils.makeRequest(GET_JOKES, "get", (res) {
        // Api method

        Response _res = res;
        print(_res.headers);
        var jokes = jsonDecode(_res.body);
        DataList dummy = DataList.fromJson(jokes);
        //print(dummy.size);
        if (dummy.size == _entries?.size) {
          return;
        }
        setState(() {
          _entries = dummy;
        });
      }, () {
        setInternet(false);
      });
    } else {
      setInternet(false);

      LocalStorage().loadStorage().then((list) {
        //
        setState(() {
          _entries = list;
        });
      });
    }
    // TODO: file-to-server synchronization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _entries == null ? 0 : _entries!.size,
                  itemBuilder: ((context, index) {
                    return ListEntry(
                      Joke: _entries!.list[index],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
