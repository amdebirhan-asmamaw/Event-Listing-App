import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;
  static const String bookedKey = 'booked_events_v1';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<String> getBookedIds() {
    return _prefs.getStringList(bookedKey) ?? <String>[];
  }

  static Future<void> setBookedIds(List<String> ids) async {
    await _prefs.setStringList(bookedKey, ids);
  }
}
