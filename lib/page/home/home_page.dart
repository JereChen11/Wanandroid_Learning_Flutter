import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/model/banner_data.dart';
import 'package:wanandroid_learning_flutter/model/collect_article_bean.dart';
import 'package:wanandroid_learning_flutter/page/search/search_page.dart';
import 'package:wanandroid_learning_flutter/res/dimens.dart';
import 'package:wanandroid_learning_flutter/widget/banner.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

import '../login/login_page.dart';
import '../web_view_page.dart';

class HomePage extends StatefulWidget {
  @override
  _ArticleListViewState createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<HomePage> {
  List<Article> articleDataList = [];
  List<BannerBean> bannerDataList = <BannerBean>[];
  int _pageNumber = 0;

  void _retrieveBannerData() async {
    ApiService().getHomeBanner((BannerData bannerData) {
      setState(() {
        bannerDataList.addAll(bannerData.bannerBean);
      });
    });
  }

  void _retrieveArticleData(int pageNumber) async {
    ApiService().getHomeArticleList(pageNumber, (ArticleBean articleBean) {
      setState(() {
        articleDataList.addAll(articleBean.data.articles);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveArticleData(_pageNumber);
    _retrieveBannerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.blue,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 30,
                    margin: EdgeInsets.only(
                        left: Dimens.default_padding,
                        right: Dimens.default_padding),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: Dimens.default_padding,
                              right: Dimens.default_padding / 2),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        Text(
                          "Search",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.default_size_sp),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage())),
                ),
                background: bannerView(bannerDataList),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: articleDataList.length,
          itemBuilder: (context, index) {
            if (index == articleDataList.length - 1) {
              _retrieveArticleData(++_pageNumber);
              return MyCircularProgressIndicator();
            }

            return GestureDetector(
              child: ArticleListItemWidget(articleDataList[index]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WebViewPage(articleDataList[index].link)));
              },
            );
          },
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}

class ArticleListItemWidget extends StatefulWidget {
  Article article;

  ArticleListItemWidget(this.article);

  @override
  _ArticleListItemWidgetState createState() =>
      _ArticleListItemWidgetState(article);
}

class _ArticleListItemWidgetState extends State<ArticleListItemWidget> {
  Article _article;
  IconData _isCollectedIcon = Icons.favorite_border;

  _ArticleListItemWidgetState(this._article);

  void _collectArticle(int articleId) async {
    ApiService().collectArticle(articleId,
        (CollectArticleBean collectArticleBean) {
      if (collectArticleBean.errorCode == 0) {
        setState(() {
          _article.collect = true;
          _isCollectedIcon = Icons.favorite;
        });
      } else if (collectArticleBean.errorCode == -1001) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  void _uncollectedArticle(int articleId) async {
    ApiService().uncollectedArticle(articleId,
        (CollectArticleBean collectArticleBean) {
      if (collectArticleBean.errorCode == 0) {
        setState(() {
          _article.collect = false;
          _isCollectedIcon = Icons.favorite_border;
        });
      }
    });
  }

  @override
  void initState() {
    if (_article.collect) {
      _isCollectedIcon = Icons.favorite;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, offset: Offset(2.0, 2.0), blurRadius: 4.0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _article.title,
            style: TextStyle(fontSize: 16, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  _article.author.isEmpty
                      ? (_article.shareUser == null
                          ? "UnKnow"
                          : _article.shareUser)
                      : _article.author,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    _article.niceDate,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(
                    _isCollectedIcon,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    print(
                        "jereTest print iconButton _article.id = ${_article.id}");
                    if (_article.collect) {
                      _uncollectedArticle(_article.originId == null
                          ? _article.id
                          : _article.originId);
                    } else {
                      _collectArticle(_article.id);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget bannerView(List<BannerBean> bannerDataList) {
  List<String> bannerUrlList = new List();
  bannerDataList.forEach((element) {
    bannerUrlList.add(element.imagePath);
  });
  return BannerView(
    data: bannerUrlList,
    buildShowView: (index, data) {
      return Image.network(
        data,
        fit: BoxFit.cover,
        height: 20,
      );
    },
    onBannerClickListener: (index, data) {
      print(index);
    },
  );
}
