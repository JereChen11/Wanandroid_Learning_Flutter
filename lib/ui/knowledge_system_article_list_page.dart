import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/ui/home_page.dart';
import 'package:wanandroid_learning_flutter/widget/MyCircularProgressIndicator.dart';

import 'BrowserWebView.dart';

class KnowledgeSystemArticleListPage extends StatefulWidget {
  String titleName;
  int cid;

  KnowledgeSystemArticleListPage(this.titleName, this.cid);

  @override
  _KnowledgeSystemArticleListPageState createState() =>
      _KnowledgeSystemArticleListPageState(titleName, cid);
}

class _KnowledgeSystemArticleListPageState
    extends State<KnowledgeSystemArticleListPage> {
  int _pageNumber = 0;
  int _cid;
  bool _isLoadAllData = false;
  String _titleName;
  List<Article> articleList = List();

  _KnowledgeSystemArticleListPageState(this._titleName, this._cid);

  @override
  void initState() {
    print("_titleNam = $_titleName, _cid = $_cid");
    _retrieveKnowledgeSystemArticle(_pageNumber);
    super.initState();
  }

  void _retrieveKnowledgeSystemArticle(int pageNumber) async {
    try {
      Response response = await Dio().get(
          "https://www.wanandroid.com/article/list/$pageNumber/json?cid=$_cid");
      print("_retrieveKnowledgeSystemArticle = $response");
      ArticleBean articleBean = ArticleBean.fromJson(response.data);
      print(
          "_retrieveKnowledgeSystemArticle articleBean.data.articles.length = ${articleBean.data.articles.length}");
      if (articleBean.data != null) {
        _isLoadAllData = articleBean.data.over;
      }
      if (_isLoadAllData) {
        articleList.addAll(articleBean.data.articles);
        articleList.add(null);//用于展示所有文章都以被加载
      }
      setState(() {});
    } catch (e) {
      print("_retrieveKnowledgeSystemArticle catch exception = $e");
    }
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
              if (!_isLoadAllData) {
                _retrieveKnowledgeSystemArticle(_pageNumber++);
                return MyCircularProgressIndicator();
              } else {
                return Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    "所有文章都已被加载",
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
                              BrowserWebView(articleList[index].link)));
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
