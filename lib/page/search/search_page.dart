import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/model/article_category_bean.dart';

class SearchPage extends SearchDelegate<Category> {
  final List<Category> data;

  SearchPage(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.grey,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Category> list = query.isEmpty
        ? data
        : data.where((p) => p.name.toLowerCase().startsWith(query)).toList();
    return list.isEmpty
        ? Center(
            child: Text(
              'No Result Found... 🙄️',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, int) {
              final item = list[int];
              return ListTile(
                title: Text(item.name),
                onTap: () {
                  close(context, null);

//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => CompleteProjectListPage(item),
//                    ),
//                  );
                },
              );
            },
          );
  }
}
