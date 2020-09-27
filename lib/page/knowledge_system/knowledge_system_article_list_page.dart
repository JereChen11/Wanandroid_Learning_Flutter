import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/page/home/home_page.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

import '../web_view_page.dart';

class KnowledgeSystemArticleListPage extends StatefulWidget {
  String titleName;
  int categoryId;

  KnowledgeSystemArticleListPage(this.titleName, this.categoryId);

  @override
  _KnowledgeSystemArticleListPageState createState() =>
      _KnowledgeSystemArticleListPageState(titleName, categoryId);
}

class _KnowledgeSystemArticleListPageState
    extends State<KnowledgeSystemArticleListPage> {
  int _pageNumber = 0;
  int _categoryId;
  bool _isLoadAllArticles = false;
  String _titleName;
  List<Article> articleList = List();

  _KnowledgeSystemArticleListPageState(this._titleName, this._categoryId);

  @override
  void initState() {
    print("_titleName = $_titleName, _categoryId = $_categoryId");
    _retrieveKnowledgeSystemArticle(_pageNumber);
    super.initState();
  }

  void _retrieveKnowledgeSystemArticle(int pageNumber) async {
    ApiService().getKnowledgeSystemArticleData(pageNumber, _categoryId,
        (ArticleBean articleBean) {
      setState(() {
        if (articleBean.data != null) {
          _isLoadAllArticles = articleBean.data.over;
          articleList.addAll(articleBean.data.articles);
        }
        if (_isLoadAllArticles) {
          articleList.add(null); //用于展示所有文章都以被加载
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == articleList.length - 1) {
              if (!_isLoadAllArticles) {
                _retrieveKnowledgeSystemArticle(++_pageNumber);
                return MyCircularProgressIndicator();
              } else {
                return Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    Strings.IS_LOAD_ALL_ARTICLE_CN,
                  ),
                );
              }
            } else {
              return GestureDetector(
                child: ListItemWidget(articleList[index]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewPage(articleList[index].link)));
                },
              );
            }
          },
          itemCount: articleList.length,
        ),
      ),
    );
  }
}
