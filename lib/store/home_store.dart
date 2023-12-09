import 'package:flutter/material.dart';
import 'package:leitordeebook/classes/Book.dart';
import 'package:leitordeebook/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStore extends ChangeNotifier {
  final controller = HomeController();

  List<Book> books = [];
  List<Book> _favoriteBooks = [];
  bool isLoading = false;
  String error = '';

  HomeStore() {
    loadBooks();
    notifyListeners();
  }

  void loadBooks() async {
    try {
      isLoading = true;
      books = await controller.fetchBooks();

      print('Home Store: $books');

      notifyListeners();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isBookFavorite(Book book) {
    return _favoriteBooks.contains(book);
  }

  // Método para adicionar ou remover um livro da lista de favoritos
  void toggleFavorite(Book book) {
    if (isBookFavorite(book)) {
      _favoriteBooks.remove(book);
    } else {
      _favoriteBooks.add(book);
    }

    // Salva a lista de favoritos no SharedPreferences
    saveFavorites();
    notifyListeners();
  }

  // Método para salvar a lista de favoritos no SharedPreferences
  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> favoriteIds =
        _favoriteBooks.map((book) => book.id.toString()).toList();
    prefs.setStringList('favorite_books', favoriteIds);
  }

  // Método para carregar a lista de favoritos do SharedPreferences
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteIds = prefs.getStringList('favorite_books');

    if (favoriteIds != null) {
      _favoriteBooks = books
          .where((book) => favoriteIds.contains(book.id.toString()))
          .toList();
    }

    notifyListeners();
  }
}
