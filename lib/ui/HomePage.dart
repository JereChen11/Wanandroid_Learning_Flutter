import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/home_article_entity.dart';
import 'package:wanandroid_learning_flutter/ui/BrowserWebView.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ArticleListView(),
    );
  }
}

class ArticleListView extends StatefulWidget {
  @override
  _ArticleListViewState createState() => new _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> {
  List<HomeArticleDataData> articleData = new List();
  int _pageNumber = 0;

  @override
  void initState() {
    super.initState();
    _retrieveArticleData(_pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articleData.length,
      itemBuilder: (context, index) {
        if(index == articleData.length - 1) {
          _retrieveArticleData(_pageNumber++);
          return Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2,),
            ),
          );
        }

        return new GestureDetector(
          child: _ListItemWidget(articleData[index]),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BrowserWebView(articleData[index].link)));
          },
        );
      },
      scrollDirection: Axis.vertical,
    );
  }

  void _retrieveArticleData(int pageNumber) async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/article/list/$pageNumber/json");
      print(response);
      HomeArticleEntity homeArticleEntity =
          JsonConvert.fromJsonAsT(response.data);
      setState(() {
        articleData.addAll(homeArticleEntity.data.datas);
      });
    } catch (e) {
      print(e);
    }
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
