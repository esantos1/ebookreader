import 'package:flutter/material.dart';
import 'dart:io';
import 'package:leitordeebook/classes/book.dart';
import 'package:leitordeebook/store/favorites_store.dart';
import 'package:leitordeebook/store/home_store.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BooksView extends StatelessWidget {
  BooksView({super.key});

  bool isDownloading = false;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    final homeStore = Provider.of<HomeStore>(context);
    final favoritesStore = Provider.of<FavoritesStore>(context);

    return ListenableBuilder(
      listenable: homeStore,
      builder: (context, child) {
        Widget body = _getBody(context, homeStore, favoritesStore);

        return body;
      },
    );
  }

  Widget _getBody(
      BuildContext context, HomeStore store, FavoritesStore favoritesStore) {
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
      return _errorBody(context, store);
    } else {
      return _loadedBooksBody(store, favoritesStore);
    }
  }

  Widget _loadedBooksBody(HomeStore store, FavoritesStore favoritesStore) =>
      GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: store.books.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
          mainAxisExtent: 165,
        ),
        itemBuilder: (context, index) {
          final item = store.books[index];

          return _buildItem(context, store, favoritesStore, item);
        },
      );

  Widget _buildItem(
    BuildContext context,
    HomeStore store,
    FavoritesStore favoritesStore,
    Book book,
  ) {
    bool isFavorite = favoritesStore.isBookFavorite(book.id.toString());

    return InkWell(
      onTap: openBook,
      onLongPress: () {
        print('Longa pressão no livro ${book.title}');
      },
      child: Container(
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
                    onTap: () =>
                        favoritesStore.toggleFavorite(book.id.toString()),
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
                    onTap: () => requestDownloadPermission(book),
                    child: isDownloading
                        ? CircularProgressIndicator(value: progress)
                        : Icon(Icons.download_for_offline),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              book.title,
              style: Theme.of(context).textTheme.bodyMedium,
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

  Widget _errorBody(BuildContext context, HomeStore store) => Column(
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
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
              onPressed: store.loadBooks,
              child: Text(
                'Tentar novamente',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      );

  Future<void> requestDownloadPermission(Book book) async {
    final permissionStatus = await Permission.storage.request();

    if (permissionStatus.isDenied) {
      print('Permissão negada');
    } else {
      await downloadBook(book);
    }
  }

  void showAlertDialog(BuildContext context, Book book) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Permissão negada!'),
            content: Text('Habilite a permissão para armazenar o ebook.'),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => requestDownloadPermission(book),
                child: Text('Configurações'),
              ),
            ],
          );
        },
      );

  Future<void> downloadBook(Book book) async {
    const downloadsPath = '/storage/emulated/0/Download';
    final filePath = path.join(
      downloadsPath,
      'ebooks',
      '${book.title} - ${book.author}.epub',
    );

    try {
      final response = await http.get(Uri.parse(book.downloadUrl));

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.create(recursive: true);

        var contentLength = response.contentLength ?? -1;
        var receivedBytes = 0;
        var fileSink = file.openWrite();

        fileSink.add(response.bodyBytes);
        receivedBytes += response.bodyBytes.length;

        if (contentLength != -1) {
          var progress = (receivedBytes / contentLength * 100).toInt();
          print('Progresso: $progress%');
        }

        await fileSink.close();

        print('Download concluído. Imagem salva em: $filePath');
      } else {
        print(
            'Erro ao baixar a imagem. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao baixar e salvar a imagem: $e');
    }
  }

  void openBook() {
    print('abrindo...');
  }
}
