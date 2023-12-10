import 'package:flutter/material.dart';
import 'package:leitordeebook/classes/book.dart';
import 'package:leitordeebook/controllers/home_controller.dart';

class HomeStore extends ChangeNotifier {
  final _controller = HomeController();

  List<Book> books = [];
  bool isLoading = false;
  String error = '';

  HomeStore() {
    loadBooks();
  }

  void loadBooks() async {
    try {
      isLoading = true;
      books = await _controller.fetchBooks();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
