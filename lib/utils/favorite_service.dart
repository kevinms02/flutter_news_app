import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('fav') ?? [];
  }

  static Future<void> toggle(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> fav = prefs.getStringList('fav') ?? [];

    if (fav.contains(id.toString())) {
      fav.remove(id.toString());
    } else {
      fav.add(id.toString());
    }

    await prefs.setStringList('fav', fav);
  }
}
