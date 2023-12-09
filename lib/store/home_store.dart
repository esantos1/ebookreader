import 'package:flutter/material.dart';
import 'package:leitordeebook/classes/book.dart';
import 'package:leitordeebook/controllers/home_controller.dart';
import 'package:leitordeebook/services/app_storage_service.dart';

class HomeStore extends ChangeNotifier {
  final controller = HomeController();
  final storage = AppStorageService();

  List<Book> books = [];
  List<String> favoriteBooks = [];
  bool isLoading = false;
  String error = '';

  HomeStore() {
    loadBooks();
    loadFavorites();
  }

  void loadBooks() async {
    try {
      isLoading = true;
      books = await controller.fetchBooks();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isBookFavorite(String bookId) {
    return favoriteBooks.contains(bookId);
  }

  void toggleFavorite(String bookId) {
    if (isBookFavorite(bookId)) {
      favoriteBooks.remove(bookId);
    } else {
      favoriteBooks.add(bookId);
    }

    debugPrint('toggleFavorite: ${favoriteBooks}');

    saveFavorites();
    notifyListeners();
  }

  void loadFavorites() async {
    favoriteBooks = await storage.loadFavorites(favoriteBooks) ?? [];

    notifyListeners();
  }

  void saveFavorites() async => await storage.saveFavorites(favoriteBooks);
}
