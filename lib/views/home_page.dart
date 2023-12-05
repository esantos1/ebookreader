import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:leitordeebook/classes/Book.dart';
import 'package:leitordeebook/controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  late List<Book> books;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadBooks();
  }

  void loadBooks() async {
    books = await controller.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
