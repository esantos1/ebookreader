import 'package:leitordeebook/classes/book.dart';
import 'package:leitordeebook/helpers/dio_helper.dart';

class HomeController {
  Future<List<Book>> fetchBooks() async {
    const url = 'https://escribo.com/books.json';

    final dioHelper = DioHelper();
    final response = await dioHelper.get(url);

    if (response.statusCode == 200) {
      final body = response.data;

      return body.map<Book>((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Houve um erro ao carregar os livros');
    }
  }
}
