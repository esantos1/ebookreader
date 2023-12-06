import 'package:flutter/material.dart';
import 'package:leitordeebook/classes/Book.dart';
import 'package:leitordeebook/controllers/home_controller.dart';

class HomeStore extends ChangeNotifier {
  final controller = HomeController();

  List<Book> books = [];
  bool isLoading = false;
  String error = '';

  HomeStore() {
    loadBooks();
  }

  void loadBooks() async {
    try {
      isLoading = true;
      books = [
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
        Book(
          id: 1,
          title: 'Lorem',
          author: 'Lorem Ipsum',
          coverUrl: 'https:aaa.com',
          downloadUrl: 'https:aaa.com',
        ),
      ];
      notifyListeners();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
