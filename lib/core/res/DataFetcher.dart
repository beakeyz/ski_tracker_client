
import 'package:location/location.dart';

class DataFetcher {

  static Future<LocationData?> getPhysicalDevicePosition() async {
    PermissionStatus perm = await Location.instance.hasPermission();
    bool service;

    service = await Location.instance.serviceEnabled();

    /* Check if we have location services */
    if (!service) {
      service = await Location.instance.requestService();

      if (!service) {
        return null;
      }
    }

    /* Check if we have location permissions */
    switch (perm) {
      case PermissionStatus.denied:
      case PermissionStatus.deniedForever:
        perm = await Location.instance.requestPermission();

        if (perm != PermissionStatus.granted) {
          return null;
        }
        break;
      default:
        break;
    }

    /* Check if we have a persistant location permission */
    service = await Location.instance.isBackgroundModeEnabled();

    if (!service) {
      service = await Location.instance.enableBackgroundMode();

      if (!service) {
        return null;
      }
    }

    return await Location.instance.getLocation();
  }
}