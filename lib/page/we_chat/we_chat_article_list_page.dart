import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

import '../web_view_page.dart';
import '../home/home_page.dart';

class WeChatArticleListPage extends StatefulWidget {
  int bloggerId;

  WeChatArticleListPage(this.bloggerId);

  @override
  _WeChatArticleListPageState createState() =>
      _WeChatArticleListPageState(bloggerId);
}

class _WeChatArticleListPageState extends State<WeChatArticleListPage> {
  int _bloggerId;

  _WeChatArticleListPageState(this._bloggerId);

  List<Article> _articleList = List();
  bool _isLoadAllArticles = false;
  int _pageNumber = 0;

  void _getWeChatArticleListData(int pageNumber) {
    ApiService().getWeChatArticleData(_bloggerId, pageNumber,
        (ArticleBean articleBean) {
      setState(() {
        if (articleBean.data != null) {
          _isLoadAllArticles = articleBean.data.over;
          _articleList.addAll(articleBean.data.articles);
        }
        if (_isLoadAllArticles) {
          _articleList.add(null); //用于展示所有文章都以被加载
        }
//        if (articleBean.errorCode == 0 &&
//            articleBean.data.articles.length > 0) {
//          _articleList.addAll(articleBean.data.articles);
//          _isLoadAllArticles = false;
//        } else {
//          _isLoadAllArticles = true;
//        }
      });
    });
  }

  @override
  void initState() {
    _getWeChatArticleListData(_pageNumber);
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
                _getWeChatArticleListData(++_pageNumber);
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
                child: ArticleListItemWidget(_articleList[index]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewPage(_articleList[index].link)));
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
