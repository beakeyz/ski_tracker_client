import 'dart:async';

import 'package:skitracker_client/core/models/DataEntry.dart';
import 'package:skitracker_client/core/models/LocalStorage.dart';
import 'package:skitracker_client/core/models/Settings.dart';
import 'package:skitracker_client/widgets/button.dart';
import 'package:skitracker_client/widgets/pos_infobox.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  double lastAltitude = 0;
  double distanceTrackedMetres = 0;
  bool isTracking = false;
  int lastTrackTime = 0;
  DateTime? trackStartTime;
  Position? currentPosition;
  StreamSubscription<Position>? currentPositionSubscription;

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

  @override
  void initState() {
    super.initState();

    currentPositionSubscription ??= Geolocator.getPositionStream(locationSettings: const LocationSettings()).listen((event) {

      final int deltaTime = event.timestamp.millisecondsSinceEpoch - lastTrackTime;

      // sadly we do have to rerender on every location update =(
      setState(() {
        trackStartTime ??= event.timestamp;

        if (isTracking) {
          trackStartTime = event.timestamp;
        }

        if (event.speed > maxSpeed) {
          maxSpeed = event.speed;
        }
        currentPosition = event;

        if (lastAltitude != 0) {
          double altitudeDelta = event.altitude - lastAltitude;

          /* Compute the total height difference throughout the track */
          if (altitudeDelta > 0) {
            upDistance += altitudeDelta;
          } else {
            downDistance += altitudeDelta.abs();
          }
        }
        
        if (isTracking) {
          // only do meaningful things with the data once we are tracking
          double deltatimeSeconds = deltaTime.toDouble() / 1000.toDouble();
          distanceTrackedMetres += (event.speed * deltatimeSeconds);
        }
      });
    
      lastAltitude = event.altitude;
      lastTrackTime = event.timestamp.millisecondsSinceEpoch;
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

    try {
      String time = DateUtils.dateOnly(trackStartTime!).toString().split(" ")[0];
      double maxSpeedKmU = (maxSpeed * 3.6);
      int distanceMetres = distanceTrackedMetres.toInt();

      // NOTE: We are NOT going to trust the client about what the index is, so this will be a funny number =)
      // We ARE going to trust the user with the strings it sends (for now)
      DataEntry entry = DataEntry(
        horizontalDistance: distanceMetres,
        upDistance: upDistance,
        downDistance: downDistance,
        maxSpeed: maxSpeedKmU,
        date: time,
        index: 69
      );

      /* Invoke the local storage manager to save this entry */
      LocalStorage().saveToStorage(entry, () {
        setState(() {
        });
      });
    } catch(_) {}
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
                  /* Don't track if the geolocator is not yet online */
                  if (trackStartTime == null) {
                    return;
                  }

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
                child: Text(
                  trackStartTime == null ?
                    "Can't start tracking yet!" : 
                    (isTracking ? 
                      "Tracking..." :
                      "Tap to start tracking!"
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
