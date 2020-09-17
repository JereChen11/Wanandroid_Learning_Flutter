import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/banner_data.dart';
import 'package:wanandroid_learning_flutter/model/home_article_entity.dart';
import 'package:wanandroid_learning_flutter/res/dimens.dart';
import 'package:wanandroid_learning_flutter/ui/search_page.dart';
import 'package:wanandroid_learning_flutter/widget/banner.dart';

import 'BrowserWebView.dart';
import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  @override
  _ArticleListViewState createState() => new _ArticleListViewState();
}

class _ArticleListViewState extends State<HomePage> {
  List<HomeArticleDataData> articleData = new List();
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
      HomeArticleEntity homeArticleEntity =
          JsonConvert.fromJsonAsT(response.data);
      setState(() {
        articleData.addAll(homeArticleEntity.data.datas);
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
              return Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            return new GestureDetector(
              child: _ListItemWidget(articleData[index]),
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

class _ListItemWidget extends StatefulWidget {
  HomeArticleDataData data;

  _ListItemWidget(HomeArticleDataData data) {
    this.data = data;
  }

  @override
  _ListItemWidgetState createState() => new _ListItemWidgetState(data);
}

class _ListItemWidgetState extends State<_ListItemWidget> {
  HomeArticleDataData data;
  IconData _isCollectedIcon = Icons.favorite_border;

  _ListItemWidgetState(HomeArticleDataData data) {
    this.data = data;
  }

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
            data.title,
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
                    data.author.isEmpty ? data.shareUser : data.author,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                )),
            new Expanded(
              child: new Container(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: new Text(
                  data.niceDate,
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
      print("index = $index, data = $data");
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
