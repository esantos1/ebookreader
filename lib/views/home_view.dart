import 'package:flutter/material.dart';
import 'package:leitordeebook/models/tab_bar_model.dart';
import 'package:leitordeebook/views/books_view.dart';
import 'package:leitordeebook/views/favorites_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tabs = [
    TabBarModel(
      tab: Tab(icon: Icon(Icons.book)),
      screen: BooksView(),
    ),
    TabBarModel(
      tab: Tab(icon: Icon(Icons.bookmark)),
      screen: FavoritesView(),
    ),
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
        child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Leitor de ebook'),
              bottom: TabBar(tabs: tabs.map((e) => e.tab).toList()),
            ),
            body: TabBarView(children: tabs.map((e) => e.screen).toList()),
          ),
        ),
      );
}
