import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/model/banner_data.dart';
import 'package:wanandroid_learning_flutter/res/dimens.dart';
import 'package:wanandroid_learning_flutter/widget/MyCircularProgressIndicator.dart';
import 'package:wanandroid_learning_flutter/widget/banner.dart';

import 'BrowserWebView.dart';
import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  _ArticleListViewState createState() => new _ArticleListViewState();
}

class _ArticleListViewState extends State<HomePage> {
  List<Article> articleData = new List();
  List<BannerBean> bannerDataList = new List();
  int _pageNumber = 0;

  void _retrieveBannerData() async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/banner/json");
      BannerData bannerData = BannerData.fromJson(response.data);
      setState(() {
        bannerDataList.addAll(bannerData.bannerBean);
      });
    } catch (e) {
      print("catch e = $e");
    }
  }

  void _retrieveArticleData(int pageNumber) async {
    try {
      Response response = await Dio()
          .get("https://www.wanandroid.com/article/list/$pageNumber/json");
      ArticleBean articleBean = ArticleBean.fromJson(response.data);
      setState(() {
        articleData.addAll(articleBean.data.articles);
      });
    } catch (e) {
      print(e);
    }
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
                      MaterialPageRoute(builder: (context) => LoginPage())),
                ),
                background: bannerView(bannerDataList),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: articleData.length,
          itemBuilder: (context, index) {
            if (index == articleData.length - 1) {
              _retrieveArticleData(_pageNumber++);
              return MyCircularProgressIndicator();
            }

            return new GestureDetector(
              child: ListItemWidget(articleData[index]),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BrowserWebView(articleData[index].link)));
              },
            );
          },
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}

class ListItemWidget extends StatefulWidget {
  Article article;

  ListItemWidget(this.article);

  @override
  _ListItemWidgetState createState() => new _ListItemWidgetState(article);
}

class _ListItemWidgetState extends State<ListItemWidget> {
  Article _article;
  IconData _isCollectedIcon = Icons.favorite_border;

  _ListItemWidgetState(this._article);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(left: 10, top: 12, bottom: 10),
          child: new Text(
            _article.title,
            style: TextStyle(fontSize: 15, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 60,
                  ),
                  child: new Text(
                    _article.author.isEmpty ? _article.shareUser : _article.author,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                )),
            new Expanded(
              child: new Container(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: new Text(
                  _article.niceDate,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(right: 10),
              child: new IconButton(
                alignment: Alignment.topCenter,
                color: Colors.yellowAccent,
                icon: new Icon(
                  _isCollectedIcon,
                  color: Colors.red,
                ),
                onPressed: () {
                  print("jereTest print iconButton");
//                  setState() {
//                    _isCollectedIcon = Icons.favorite;
//                  }
                  _isCollectedIcon = Icons.favorite;
                },
              ),
            ),
          ],
        ),
        new Container(
          color: Colors.grey,
          width: MediaQuery.of(context).size.width,
          height: 1,
        ),
      ],
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
