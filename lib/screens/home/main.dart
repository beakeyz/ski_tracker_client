import 'dart:async';

import 'package:skitracker_client/core/models/DataEntry.dart';
import 'package:skitracker_client/core/models/LocalStorage.dart';
import 'package:skitracker_client/core/models/Settings.dart';
import 'package:skitracker_client/core/tracker.dart';
import 'package:skitracker_client/widgets/button.dart';
import 'package:skitracker_client/widgets/pos_infobox.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MainScreen extends StatefulWidget {


  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //final TextEditingController summaryController = TextEditingController();
  //final TextEditingController contentController = TextEditingController();

  String responseText = "Send";
  SliderSetting? freqSlider;

  double maxSpeed = 0;
  double upDistance = 0;
  double downDistance = 0;
  double distanceTrackedMetres = 0;
  DateTime? trackStartTime;
  LocationData? currentPosition;

  void setResponseText(String newString) {
    if (newString.isEmpty) {
      setState(() {
        responseText = "Send";
      });
      return;
    }
    setState(() {
      responseText = newString;
    });
  }

  void updatePositionData(Tracker t) 
  {
    setState(() {
      maxSpeed = t.maxSpeed;
      upDistance = t.upDistance;
      downDistance = t.downDistance;
      distanceTrackedMetres = t.distanceTrackedMetres;
      currentPosition = t.currentPosition;
    });
  }

  @override
  void initState() {
    super.initState();

    gTracker!.setPosUpdateFunc(updatePositionData);
  }

  @override
  void dispose() {
    super.dispose();
    //summaryController.dispose();

    gTracker!.setPosUpdateFunc(null);
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
    try {
      String time = DateUtils.dateOnly(trackStartTime!).toString().split(" ")[0];
      double maxSpeedKmU = (maxSpeed * 3.6);
      int distanceMetres = distanceTrackedMetres.toInt();

      int timeDelta = DateTime.now().millisecondsSinceEpoch - trackStartTime!.millisecondsSinceEpoch;

      // NOTE: We are NOT going to trust the client about what the index is, so this will be a funny number =)
      // We ARE going to trust the user with the strings it sends (for now)
      DataEntry entry = DataEntry(
        horizontalDistance: distanceMetres,
        upDistance: upDistance,
        downDistance: downDistance,
        maxSpeed: maxSpeedKmU,
        trackTimeSec: timeDelta / 1000,
        date: time,
        index: 69
      );

      /* Invoke the local storage manager to save this entry */
      LocalStorage().saveToStorage(entry, () {
        setState(() {
        });
      });
    } catch(_) {
      print("FAILED TO PROCESS TRACK LOCALLY");
    }
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
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PositionInfoBox(
                    title: "Distance",
                    type: InfoBoxInfoType.DISTANCE_TRACKED,
                    distance: distanceTrackedMetres,
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

                  if (gTracker!.canStartTracking == false) {
                    return;
                  }

                  if (gTracker!.isTracking) {
                    // stop tracking and save tracked info
                    trackStartTime = gTracker!.trackStartTime;
                    processTrackLocally();
                  }

                  /* Do the toggle */
                  setState(() {
                    gTracker!.toggleTracker();
                  });
                },
                child: Text(
                  gTracker!.canStartTracking == false ?
                    "Can't start tracking yet!" : 
                    (gTracker!.isTracking ? 
                      "Tracking (Tap again to stop)" :
                      "Tap to start tracking"
                      )
                ),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
}
