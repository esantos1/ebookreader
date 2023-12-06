import 'package:flutter/material.dart';
import 'package:leitordeebook/store/home_store.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final store = HomeStore();

  @override
  Widget build(BuildContext context) {
    Widget body = _getBody(context);

    return Scaffold(
      body: body,
    );
  }

  Widget _getBody(BuildContext context) {
    if (store.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (store.books.isNotEmpty) {
      return _loadedBooksBody();
    } else if (store.books.isEmpty) {
      return Center(
        child: Text(
          'Nenhum livro para mostrar',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      );
    } else {
      return _errorBody(context);
    }
  }

  Widget _loadedBooksBody() {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      itemCount: store.books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 160,
      ),
      itemBuilder: (context, index) {
        final item = store.books[index];

        return InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            width: 50,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  constraints: BoxConstraints(maxHeight: 70),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.network(
                        'https://editoraflutuante.com.br/wp-content/uploads/2018/08/Quarta-Capa-Frente-1.jpg'),
                  ),
                ),
                Text(item.title),
                Text(item.author, style: TextStyle()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _errorBody(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Digite um número a ser calculado:',
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
}
