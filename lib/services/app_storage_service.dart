import 'package:shared_preferences/shared_preferences.dart';

enum _StorageKeys { favoriteBooks, bookPath }

class AppStorageService {
  Future<void> saveFavorites(List<String> favoriteBooksIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = favoriteBooksIds.map((book) => book).toList();

    await prefs.setStringList(_StorageKeys.favoriteBooks.name, favoriteIds);
  }

  Future<List<String>?> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_StorageKeys.favoriteBooks.name);
  }

  Future<void> saveFilePath(List<String> listPaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_StorageKeys.bookPath.name, listPaths);
  }

  Future<List<String>?> loadFilePaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_StorageKeys.bookPath.name);
  }
}
