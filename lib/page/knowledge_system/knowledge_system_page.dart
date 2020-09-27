import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_category_bean.dart';
import 'package:wanandroid_learning_flutter/page/knowledge_system/knowledge_system_article_list_page.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

class KnowledgeSystemPage extends StatefulWidget {
  @override
  _KnowledgeSystemPageState createState() => _KnowledgeSystemPageState();
}

class _KnowledgeSystemPageState extends State<KnowledgeSystemPage> {
  ArticleCategoryBean _articleCategoryBean;

  void _getKnowledgeSystemCategory() async {
    ApiService().getKnowledgeSystemArticleCategory(
        (ArticleCategoryBean articleCategoryBean) {
      setState(() {
        _articleCategoryBean = articleCategoryBean;
      });
    });
  }

  @override
  void initState() {
    _getKnowledgeSystemCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_articleCategoryBean == null ||
        _articleCategoryBean.category.length == 0) {
      return Center(
        child: MyCircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                new ExpansionItem(_articleCategoryBean.category[index]),
            itemCount: _articleCategoryBean.category.length,
          ),
        ),
      );
    }
  }
}

class ExpansionItem extends StatelessWidget {
  Category _category;

  ExpansionItem(this._category);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.menu),
      title: Text(_category.name),
      children: <Widget>[
        ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15, left: 30),
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).cardTheme.color,
                elevation: 30,
                shadowColor: Colors.black.withOpacity(0.3),
                margin: const EdgeInsets.only(right: 25),
                child: InkWell(
                  splashColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                KnowledgeSystemArticleListPage(
                                    _category.children[index].name,
                                    _category.children[index].id)));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _category.children[index].name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: _category.children.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: ScrollController(),
        )
      ],
    );
  }
}
