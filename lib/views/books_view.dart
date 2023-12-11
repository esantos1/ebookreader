import 'package:flutter/material.dart';
import 'package:leitordeebook/classes/book.dart';
import 'package:leitordeebook/helpers/dio_helper.dart';
import 'package:leitordeebook/store/favorites_store.dart';
import 'package:leitordeebook/store/home_store.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
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
    final favoriteIcon = Icon(
      isFavorite ? Icons.bookmark : Icons.bookmark_border,
      color: isFavorite ? Colors.red : null,
    );

    return InkWell(
      onTap: () => openBook(context),
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  favoritesStore.toggleFavorite(book.id.toString());
                  Navigator.pop(context);
                },
                leading: favoriteIcon,
                title: Text(
                  isFavorite
                      ? 'Remover aos favoritos'
                      : 'Adicionar aos favoritos',
                ),
              ),
              ListTile(
                onTap: () {
                  downloadBook(context, book);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.download),
                title: Text('Baixar'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBox(book, favoriteIcon),
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

  Widget _imageBox(Book book, Icon favoriteIcon) {
    return Stack(
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
          child: favoriteIcon,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: isDownloading
              ? CircularProgressIndicator(value: progress)
              : Icon(Icons.download),
        ),
      ],
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

  Future<void> requestDownloadPermission(
      BuildContext context, Book book) async {
    final permissionStatus = await Permission.storage.request();

    if (permissionStatus.isDenied) {
      showAlertDialog(context, book);
    } else {
      await downloadBook(context, book);
    }
  }

  void showAlertDialog(BuildContext context, Book book) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Permissão negada!'),
          content: Text('Habilite a permissão para armazenar o ebook.'),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => requestDownloadPermission(context, book),
              child: Text('Configurações'),
            ),
          ],
        ),
      );

  Future<void> downloadBook(BuildContext context, Book book) async {
    print('baixando...');

    final downloadsPath = await path.getDownloadsDirectory();
    final filePath =
        '${downloadsPath!.path}/livros/${book.title} - ${book.author}.epub';

    final dioHelper = DioHelper();

    try {
      await dioHelper.download(book.downloadUrl, filePath);
      print('Arquivo salvo em $filePath');
    } catch (e) {
      print('Erro ao baixar e salvar ebook: $e');
    }
  }

  void openBook(BuildContext context, {String? path}) async {
    print('abrindo...');

    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "open",
      scrollDirection: EpubScrollDirection.HORIZONTAL,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    // get current locator
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: $locator');
    });

    if (path != null) {
      await VocsyEpub.openAsset(path);
    }
  }
}
