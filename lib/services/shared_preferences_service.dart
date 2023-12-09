import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final _favoriteBooksKey = 'favorite_books';

  late SharedPreferences _prefs;

  SharedPreferencesService() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<String>> getFavoriteBooks() async {
    return _prefs.getStringList(_favoriteBooksKey) ?? [];
  }

  Future<void> addFavoriteBook(String bookId) async {
    List<String> favoriteBooks = _prefs.getStringList(_favoriteBooksKey) ?? [];
    favoriteBooks.add(bookId);

    await _prefs.setStringList(_favoriteBooksKey, favoriteBooks);
  }

  Future<void> removeFavoriteBook(String bookId) async {
    List<String> favoriteBooks = _prefs.getStringList(_favoriteBooksKey) ?? [];
    favoriteBooks.remove(bookId);

    await _prefs.setStringList(_favoriteBooksKey, favoriteBooks);
  }
}
