import 'package:flutter/material.dart';
import 'package:leitordeebook/helpers/dio_helper.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:leitordeebook/classes/book.dart';

class DownloadStore extends ChangeNotifier {
  List<String> paths = [];

  DownloadStore() {
    loadPaths();
  }

  Future<void> downloadBook(Book book) async {
    print('baixando...');

    final downloadsPath = await path.getDownloadsDirectory();
    final filePath =
        '${downloadsPath!.path}/livros/${book.id}-${book.title}-${book.author}.epub';

    final dioHelper = DioHelper();

    try {
      await dioHelper.download(book.downloadUrl, filePath);
      print('Arquivo salvo em $filePath');
    } catch (e) {
      print('Erro ao baixar e salvar ebook: $e');
    }
  }

  // bool isBookDownloaded(Book book, String pathFile) {
  //   // Verifica se algum caminho na lista contém o nome do arquivo
  //   return paths.any((path) =>
  //       path['fileName'] == book.title && pathFile.contains(path['filePath']));
  // }

  void loadPaths() {}
}
