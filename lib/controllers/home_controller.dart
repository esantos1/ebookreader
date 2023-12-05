import 'dart:convert';

import 'package:leitordeebook/classes/Book.dart';
import 'package:http/http.dart' as http;

class HomeController {
  Future<List<Book>> fetchBooks() async {
    const url = 'https://escribo.com/books.json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      return body.map<Book>((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Houve um erro ao carregar os livros');
    }
  }
}
