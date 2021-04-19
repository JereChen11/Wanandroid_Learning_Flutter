import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/page/home/home_page.dart';
import 'package:wanandroid_learning_flutter/page/web_view_page.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

class SearchResultPage extends StatefulWidget {
  String _searchKeyName;

  SearchResultPage(this._searchKeyName);

  @override
  _SearchResultPageState createState() =>
      _SearchResultPageState(_searchKeyName);
}

class _SearchResultPageState extends State<SearchResultPage> {
  int _pageNumber = 0;
  bool _isLoadAllArticles = false;
  String _searchKeyName;
  List<Article> _articleList = [];

  _SearchResultPageState(this._searchKeyName);

  void _search(int pageNumber) {
    var data = {
      "k": _searchKeyName,
    };
    ApiService().search(pageNumber, data, (ArticleBean articleBean) {
      setState(() {
        if (articleBean.data != null) {
          _isLoadAllArticles = articleBean.data.over;
          _articleList.addAll(articleBean.data.articles);
        }
        if (_isLoadAllArticles) {
          _articleList.add(null); //用于展示所有文章都以被加载
        }

        _updateLocalSearch();
      });
    });
  }

  void _updateLocalSearch() {
    List<String> localSearchHistoryList =
        SpUtil().getStringList(Constant.localSearchHistoryKey);
    if (localSearchHistoryList == null) {
      localSearchHistoryList = [];
    }
    if (!localSearchHistoryList.contains(_searchKeyName)) {
      localSearchHistoryList.add(_searchKeyName);
    }
    SpUtil()
        .putStringList(Constant.localSearchHistoryKey, localSearchHistoryList);
  }

  @override
  void initState() {
    _search(_pageNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_searchKeyName),
        centerTitle: true,
      ),
      body: (_articleList.length == 0)
          ? Center(child: MyCircularProgressIndicator())
          : SafeArea(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index == _articleList.length - 1) {
                    if (!_isLoadAllArticles) {
                      _search(++_pageNumber);
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
