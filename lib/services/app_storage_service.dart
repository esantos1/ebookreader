import 'package:shared_preferences/shared_preferences.dart';

enum _StorageKeys { favoriteBooks }

class AppStorageService {
  Future<void> saveFavorites(List<String> favoriteBooks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = favoriteBooks.map((book) => book).toList();

    await prefs.setStringList(_StorageKeys.favoriteBooks.name, favoriteIds);
  }

  Future<List<String>?> loadFavorites(List<String> books) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds =
        prefs.getStringList(_StorageKeys.favoriteBooks.name);

    return favoriteIds;
  }
}
