

import 'dart:async';

import 'package:geolocator/geolocator.dart';

/*
 * This class is going to be responsible for the global tracking state
 * of the app
 */
class Tracker {

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

  Function? posUpdateFunc;

  /*
   * Tracker constructor
   */
  Tracker({ this.posUpdateFunc });

  /*
   * Set the update function of this tracker
   * Can be null
   */
  void setPosUpdateFunc(Function? func)
  {
    bool wasPaused = true;

    /* Check if we need to pause the position subscription */
    if (currentPositionSubscription != null && currentPositionSubscription!.isPaused == false) {
      currentPositionSubscription!.pause(null);
      wasPaused = false;
    }

    posUpdateFunc = func;

    /* Only resume the subscription if we just paused it ourselves */
    if (!wasPaused) {
      currentPositionSubscription!.resume();
    }
  }

  void update()
  {
    /* Pass ourselves to the update function */
    if (posUpdateFunc != null) {
      posUpdateFunc!.call(this);
    }
  }

  /*
   * Start the tracker by creating a position stream
   */
  void startTracker()
  {
    if (currentPositionSubscription != null) {
      return;
    }

    currentPositionSubscription = Geolocator.getPositionStream(locationSettings: const LocationSettings()).listen((event) {

      final int deltaTime = event.timestamp.millisecondsSinceEpoch - lastTrackTime;

      // sadly we do have to rerender on every location update =(
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

      update();
    
      lastAltitude = event.altitude;
      lastTrackTime = event.timestamp.millisecondsSinceEpoch;
    },);

    /* Ensure subscription exists */
    currentPositionSubscription!.resume();
  }

  /*
   * Stop the tracker
   * 
   * NOTE: this is sooo hacky wtf
   */
  void stopTracker()
  {
    bool done = false;
    currentPositionSubscription!.cancel().then((value) { done = true; });

    while (done == false) {}

    isTracking = false;
    currentPosition = null;
    trackStartTime = null;

    lastAltitude = 0;
    lastTrackTime = 0;

    distanceTrackedMetres = 0;
    upDistance = 0;
    downDistance = 0;
    maxSpeed = 0;
    
    update();
  }
}

Tracker? gTracker;