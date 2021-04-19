import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/page/home/home_page.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

import '../web_view_page.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  List<Article> _articleList = [];
  int _pageNumber = 0;
  bool _isLoadAllArticles = false;

  void _getCollectionArticleListData(int pageNumber) {
    ApiService().getCollectionArticleList(pageNumber,
        (ArticleBean articleBean) {
      setState(() {
        if (articleBean.data != null) {
          _isLoadAllArticles = articleBean.data.over;
          for (var article in articleBean.data.articles) {
            article.collect = true;
            _articleList.add(article);
          }
        }
        if (_isLoadAllArticles) {
          _articleList.add(null); //用于展示所有文章都以被加载
        }
      });
    });
  }

  @override
  void initState() {
    _getCollectionArticleListData(_pageNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.COLLECT_CN),
        centerTitle: true,
      ),
      body: (_articleList.length == 0)
          ? Center(child: MyCircularProgressIndicator())
          : SafeArea(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index == _articleList.length - 1) {
                    if (!_isLoadAllArticles) {
                      _getCollectionArticleListData(++_pageNumber);
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
