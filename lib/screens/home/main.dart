import 'dart:async';
import 'dart:convert';

import 'package:dadjoke_client/constants/api_endpoints.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/DataEntry.dart';
import 'package:dadjoke_client/core/models/LocalStorage.dart';
import 'package:dadjoke_client/core/res/DataFetcher.dart';
import 'package:dadjoke_client/core/res/FileManager.dart';
import 'package:dadjoke_client/core/res/JsonFileManager.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/main.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:dadjoke_client/widgets/posInfoBox.dart';
import 'package:dadjoke_client/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class MainScreen extends StatefulWidget {


  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //final TextEditingController summaryController = TextEditingController();
  //final TextEditingController contentController = TextEditingController();

  String responseText = "Send";

  double maxSpeed = 0;
  bool isTracking = false;
  int lastTrackTime = 0;
  int distanceTracked_metres = 0;
  DateTime? trackStartTime;
  Position? currentPosition;
  StreamSubscription<Position>? currentPositionSubscription;

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
        
    currentPositionSubscription ??= Geolocator.getPositionStream(locationSettings: const LocationSettings()).listen((event) {

      final int deltaTime = event.timestamp!.millisecond - lastTrackTime;

      // sadly we do have to rerender on every location update =(
      setState(() {
        if (isTracking) {
          trackStartTime ??= event.timestamp!;
        } else {
          // sanity
          trackStartTime ??= null;
        }

        if (event.speed > maxSpeed) {
          maxSpeed = event.speed;
        }
        currentPosition = event;
        lastTrackTime = event.timestamp!.millisecond;
      });

      if (isTracking) {
        // only do meaningful things with the data once we are tracking

        double deltaTime_seconds = deltaTime / 1000;
        distanceTracked_metres += (event.speed * deltaTime_seconds).toInt();
      }
    },);

    currentPositionSubscription?.resume();
  }

  @override
  void dispose() {
    super.dispose();
    //summaryController.dispose();

    currentPositionSubscription?.pause();
  }

  void processTrackToServer() {
    /*
    String time = DateUtils.dateOnly(DateTime.now()).toString().split(" ")[0];
    print(time);
    // We are NOT going to trust the client about what the index is, so this will be a funny number =)
    // We ARE going to trust the user with the strings it sends (for now)
    DataEntry entry = DataEntry(Summary: "", joke: "", Date: time, index: 69);
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
        });
      }
    }, () {
      setResponseText("Could not connect!");
    });
    */
  }

  void processTrackLocally() {
    String time = DateUtils.dateOnly(trackStartTime!).toString().split(" ")[0];
    double max_speed_km_u = (maxSpeed * 3.6);
    int distance_metres = distanceTracked_metres;

    // We are NOT going to trust the client about what the index is, so this will be a funny number =)
    // We ARE going to trust the user with the strings it sends (for now)
    DataEntry entry = DataEntry(distance: distance_metres, max_speed: max_speed_km_u, Date: time, index: 69);
    LocalStorage().saveToStorage(entry, () {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Data"),
              const SizedBox(
                height: 35,
              ),
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PositionInfoBox(
                    title: "Height",
                    type: InfoBoxInfoType.HEIGHT,
                    data: currentPosition,
                  ),
                  PositionInfoBox(
                    title: "Speed",
                    type: InfoBoxInfoType.SPEED,
                    data: currentPosition,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Button(
                callback: () {
                  if (isTracking) {
                    // stop tracking and save tracked info
                    processTrackLocally();
                    trackStartTime = null;
                  } else {
                    // start tracking so that we save position info and compute it
                  }
                  setState(() {
                    isTracking = !isTracking;
                  });
                },
                child: const Text("Hi"),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}
