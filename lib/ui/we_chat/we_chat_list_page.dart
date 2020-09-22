
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/widget/MyCircularProgressIndicator.dart';

import '../browser_web_view_page.dart';
import '../home_page.dart';

class WeChatListPage extends StatefulWidget {
  int bloggerId;

  WeChatListPage(this.bloggerId);

  @override
  _WeChatListPageState createState() => _WeChatListPageState(bloggerId);
}

class _WeChatListPageState extends State<WeChatListPage> {
  int _bloggerId;

  _WeChatListPageState(this._bloggerId);

  List<Article> _articleList = List();
  bool _isLoadAllArticles = false;
  int _pageNumber = 0;

  void _retrieveArticleListData(int pageNumber) {
    Future<ArticleBean> articleBeanFuture = _getArticleListData(pageNumber);

    articleBeanFuture.then((value) => {
      if (value.errorCode == 0 && value.data.articles.length > 0)
        {
          setState(() {
            _articleList.clear();
            _articleList.addAll(value.data.articles);
            _isLoadAllArticles = false;
          })
        }
      else
        {
          setState(() {
            _isLoadAllArticles = true;
            print("jeretest _isLoadAllArticles = $_isLoadAllArticles");
          })
        }
    });
  }

  Future<ArticleBean> _getArticleListData(int pageNumber) async {
    try {
      Response response = await Dio().get(
          "https://wanandroid.com/wxarticle/list/$_bloggerId/$pageNumber/json");
      ArticleBean articleBean = ArticleBean.fromJson(response.data);
      return articleBean;
    } catch (e) {
      print(e);
    }
  }

  void _loadMoreData(int pageNumber) {
    Future<ArticleBean> articleEntityFuture = _getArticleListData(pageNumber);
    articleEntityFuture.then((value) => {
      if (value.errorCode == 0 && value.data.articles.length > 0)
        {
          setState(() {
            _articleList.addAll(value.data.articles);
            _isLoadAllArticles = false;
          })
        }
      else
        {
          setState(() {
            _isLoadAllArticles = true;
            print("jeretest _isLoadAllArticles = $_isLoadAllArticles");
          })
        }
    });
  }

  @override
  void initState() {
    _retrieveArticleListData(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == _articleList.length - 1) {
              if (!_isLoadAllArticles) {
                _loadMoreData(_pageNumber++);
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
                child: ListItemWidget(_articleList[index]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BrowserWebViewPage(_articleList[index].link)));
                },
              );
            }
          },
          itemCount: _articleList.length,
        ),
      ),
    );
  }
}
