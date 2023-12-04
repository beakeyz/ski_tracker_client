import 'dart:convert';

import 'package:skitracker_client/constants/api_endpoints.dart';
import 'package:skitracker_client/core/api_calls.dart';
import 'package:skitracker_client/core/models/DataList.dart';
import 'package:skitracker_client/core/models/LocalStorage.dart';
import 'package:skitracker_client/core/updates/StateUpdater.dart';
import 'package:skitracker_client/main.dart';
import 'package:skitracker_client/widgets/list_entry.dart';
import 'package:skitracker_client/widgets/updates/StateUpdateWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ListScreen extends StatefulWidget {

  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  DataList? _entries;
  bool noInternet = false;

  void setInternet(bool internet) {
    setState(() {
      noInternet = internet;
    });
  }

  @override
  void initState() {
    super.initState();

    print("loading the lists...");
    if (App.hasServer) {
      ApiUtils.makeRequest(GET_JOKES, "get", (responseRaw) {
        // Api method

        Response res = responseRaw;
        print(res.headers);
        var jokes = jsonDecode(res.body);
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

      LocalStorage().loadStorage((list) {
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
      body: StateUpdateWidget(
        updater: StateUpdater(stateKey: widget.key),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _entries == null ? 0 : _entries!.size,
                    itemBuilder: ((context, index) {
                      return ListEntry(
                        dataEntry: _entries!.list[index],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
