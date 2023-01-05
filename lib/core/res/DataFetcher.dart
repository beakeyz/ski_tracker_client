import 'dart:async';
import 'package:geolocator/geolocator.dart';

class DataFetcher {

  static Future<Position?> getPhysicalDeviceHeight() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    print("Started fetch");
    if (!service) {
      print("no service");
      return null;
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();

    switch (locationPermission) {
      case LocationPermission.denied:
      print("no perms 1");
        return null;
      case LocationPermission.deniedForever:
      print("no perms 2");

        return null;
      case LocationPermission.unableToDetermine:
      print("no perms 4");
        return null;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      print("perms");
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
        );
    }
  }
}