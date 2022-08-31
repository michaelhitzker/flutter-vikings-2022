import 'package:shared_preferences/shared_preferences.dart';

const _beerCountKey = "com.michaehitzker.bev-counter.beerCount";
const _coffeeCountKey = "com.michaelhitzker.bev-counter.coffeeCount";

extension SharedPreferencesExtensions on SharedPreferences {
  int get beerCount {
    return getInt(_beerCountKey) ?? 0;
  }

  set beerCount(int newValue) {
    setInt(_beerCountKey, newValue);
  }

  int get coffeeCount {
    return getInt(_coffeeCountKey) ?? 0;
  }

  set coffeeCount(int newValue) {
    setInt(_coffeeCountKey, newValue);
  }
}
