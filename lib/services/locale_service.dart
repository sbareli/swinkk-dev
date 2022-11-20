import 'package:devicelocale/devicelocale.dart';
import 'package:geolocator/geolocator.dart';

class LocaleService {
  Future<String> getDeviceLanguage() async {
    final locale = await Devicelocale.currentLocale;
    return locale.toString().split('-').first.toLowerCase().split('_').first;
  }

  Future<Position?> currentPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return null;
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
