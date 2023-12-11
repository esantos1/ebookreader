import 'package:flutter/material.dart';
import 'package:leitordeebook/services/app_storage_service.dart';

class FavoritesStore extends ChangeNotifier {
  final storage = AppStorageService();

  List<String> favoriteBooksIds = [];

  FavoritesStore() {
    loadFavorites();
  }

  bool isBookFavorite(String bookId) => favoriteBooksIds.contains(bookId);

  void toggleFavorite(String bookId) {
    if (isBookFavorite(bookId)) {
      favoriteBooksIds.remove(bookId);
    } else {
      favoriteBooksIds.add(bookId);
    }

    favoriteBooksIds.sort();
    saveFavorites();
    notifyListeners();
  }

  void loadFavorites() async {
    favoriteBooksIds = await storage.loadFavorites() ?? [];

    notifyListeners();
  }

  void saveFavorites() async => await storage.saveFavorites(favoriteBooksIds);
}
