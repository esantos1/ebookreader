import 'package:flutter/material.dart';
import 'package:leitordeebook/classes/book.dart';
import 'package:leitordeebook/store/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = HomeStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
          listenable: store,
          builder: (context, child) {
            Widget body = _getBody(context);

            return body;
          }),
    );
  }

  Widget _getBody(BuildContext context) {
    if (store.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (store.books.isEmpty) {
      return Center(
        child: Text(
          'Nenhum livro para mostrar',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      );
    } else if (store.error.isNotEmpty) {
      return _errorBody(context);
    } else {
      return _loadedBooksBody();
    }
  }

  Widget _loadedBooksBody() {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      itemCount: store.books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        mainAxisExtent: 180,
      ),
      itemBuilder: (context, index) {
        final item = store.books[index];

        return _buildItem(item, context);
      },
    );
  }

  Widget _buildItem(Book book, BuildContext context) {
    bool isFavorite = store.isBookFavorite(book.id.toString());

    return InkWell(
      onTap: openBook,
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(border: Border.all(width: 3)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.network(book.coverUrl),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => store.toggleFavorite(book.id.toString()),
                    child: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.download_for_offline),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              book.title,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              book.author,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBody(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            store.error,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          SizedBox(height: 16),
          FractionallySizedBox(
            widthFactor: 0.45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
              ),
              onPressed: store.loadBooks,
              child: Text(
                'Tentar novamente',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      );

  void openBook() {}
}
