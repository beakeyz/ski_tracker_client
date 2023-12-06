
import 'package:location/location.dart';
import 'package:skitracker_client/core/models/Settings.dart';

/*
 * A trackpoint is a Location that we cached during 
 * a track
 */
class TrackPoint {
  double? currentSpeed;
  double? currentAltitude;

  TrackPoint({this.currentSpeed, this.currentAltitude});
}

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
  bool canStartTracking = false;
  double lastTrackTime = 0;
  DateTime? trackStartTime;
  LocationData? currentPosition;

  late List<TrackPoint> trackPoints;
  Function? posUpdateFunc;

  /*
   * Tracker constructor
   */
  Tracker({ this.posUpdateFunc })
  {
    trackPoints = List.empty(growable: true);

    /* TODO: collect every Location and do some signal smoothing */
    Location.instance.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      /* This is in ms */
      interval: 250,
    ).then((value) {

      /* Register a stream handler once we've changed the settings */
      Location.instance.onLocationChanged.forEach((event) {
        canStartTracking = true;

        if (!isTracking || event.speed == null || event.altitude == null || event.time == null) {
          return;
        }

        if (lastTrackTime == 0) {
          lastTrackTime = event.time!;
        }

        if (lastAltitude == 0) {
          lastAltitude = event.altitude!;
        }

        final double deltaTime = event.time! - lastTrackTime;

        if (event.speed! > maxSpeed) {
          maxSpeed = event.speed!;
        }

        currentPosition = event;

        if (lastAltitude != 0) {
          double altitudeDelta = event.altitude! - lastAltitude;

          /* Compute the total height difference throughout the track */
          if (altitudeDelta > 0) {
            upDistance += altitudeDelta;
          } else {
            downDistance += altitudeDelta.abs();
          }
        }

        // only do meaningful things with the data once we are tracking
        double deltatimeSeconds = deltaTime.toDouble() / 1000.toDouble();
        distanceTrackedMetres += (event.speed! * deltatimeSeconds);

        update();
      
        lastAltitude = event.altitude!;
        lastTrackTime = event.time!;
      });
    });
  }

  /*
   * Set the update function of this tracker
   * Can be null
   */
  void setPosUpdateFunc(Function? func)
  {
    posUpdateFunc = func;
  }

  void update()
  {
    /* Pass ourselves to the update function */
    if (posUpdateFunc != null) {
      posUpdateFunc!.call(this);
    }
  }

  void resetParams()
  {
    currentPosition = null;

    lastAltitude = 0;
    lastTrackTime = 0;

    distanceTrackedMetres = 0;
    upDistance = 0;
    downDistance = 0;
    maxSpeed = 0;
  }

  /*
   * Start the tracker by creating a position stream
   */
  void startTracker()
  {
    // sadly we do have to rerender on every location update =(
    trackStartTime = DateTime.now();
    isTracking = true;

    resetParams();
    update();
  }

  /*
   * Stop the tracker
   * 
   * NOTE: this is sooo hacky wtf
   */
  void stopTracker()
  {
    isTracking = false;
    trackStartTime = null;
    
    resetParams();
    update();
  }

  void toggleTracker()
  {
    /* If we are currently tracking, disable it */
    if (isTracking) {
      stopTracker();
      return;
    }
    
    startTracker();
  }
}

/*
  * Update the location frequency based on the 
  * "Frequency" setting
  */
void trackerUpdateFrequency(SliderSetting frequency) async
{
  if (gTracker == null) {
    return;
  }

  //await Location.instance.changeSettings(
  // interval: frequency.value.toInt()
  //);
}

Tracker? gTracker;