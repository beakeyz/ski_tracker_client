import 'dart:async';
import 'package:geolocator/geolocator.dart';

class DataFetcher {

  static Future<Position?> getPhysicalDevicePosition() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    print("Started fetch");
    if (!service) {
      print("no service");
      return null;
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();

    switch (locationPermission) {
      case LocationPermission.denied:
        LocationPermission perm = await Geolocator.requestPermission();

        //could not type the or opperator while writing this -_-
        if (perm == LocationPermission.always) {
          return DataFetcher.getPhysicalDevicePosition();
        }
        if (perm == LocationPermission.whileInUse) {
          return DataFetcher.getPhysicalDevicePosition();
        }
        return null;
      case LocationPermission.deniedForever:
      print("no perms 2");

        return null;
      case LocationPermission.unableToDetermine:
      print("no perms 4");
        return null;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
        );
    }
  }

  static Future<Position?> getPhysicalDeviceSpeed() async {

  }
}