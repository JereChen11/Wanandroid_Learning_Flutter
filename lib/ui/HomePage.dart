import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/home_article_entity.dart';

class HomePage extends StatelessWidget {
  _defaultTextStyle() {
    return new TextStyle(fontSize: 20, color: Colors.blue);
  }

  void getHttp() async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/article/list/2/json");
      print(response);
//      HomeArticleEntity homeArticleEntity = HomeArticleEntity(response.extra);
      HomeArticleEntity homeArticleEntity = JsonConvert.fromJsonAsT(response.data);
      print(homeArticleEntity.errorCode);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
//    getHttp();
    return new Scaffold(
      body: InfiniteListView(),
    );
  }
}

class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => new _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
//  var _words = <String>[loadingTag];
  List<HomeArticleDataData> datas = new List();

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: datas.length,
      itemBuilder: (context, index) {

        _retrieveData();


        //如果到了表尾
//        if (datas[index] == loadingTag) {
//          //不足100条，继续获取数据
//          if (datas.length - 1 < 100) {
//            //获取数据
//            _retrieveData();
//            //加载时显示loading
//            return Container(
//              padding: const EdgeInsets.all(16.0),
//              alignment: Alignment.center,
//              child: SizedBox(
//                  width: 24.0,
//                  height: 24.0,
//                  child: CircularProgressIndicator(strokeWidth: 2.0)),
//            );
//          } else {
//            //已经加载了100条数据，不再获取数据。
//            return Container(
//                alignment: Alignment.center,
//                padding: EdgeInsets.all(16.0),
//                child: Text(
//                  "没有更多了",
//                  style: TextStyle(color: Colors.grey),
//                ));
//          }
//        }
        //显示单词列表项
        return _ListItemWidget(datas[index]);
      },
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }

//  void _retrieveData() {
//    Future.delayed(Duration(seconds: 2)).then((e) {
//      setState(() {
//        //重新构建列表
//        _words.insertAll(
//            _words.length - 1,
//            //每次生成20个单词
//            generateWordPairs().take(20).map((e) => e.asPascalCase).toList());
//      });
//    });
//  }

  void _retrieveData() async {
    try {
      Response response =
      await Dio().get("https://www.wanandroid.com/article/list/2/json");
      print(response);
      HomeArticleEntity homeArticleEntity = JsonConvert.fromJsonAsT(response.data);
      setState(() {
        for(HomeArticleDataData data in homeArticleEntity.data.datas) {
          _ListItemWidget(data);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

class _ListItemWidget extends StatelessWidget {
  HomeArticleDataData data;

  _ListItemWidget(HomeArticleDataData data) {
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
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
              padding: EdgeInsets.only(left: 10, top: 2),
              child: new Text(
                data.author,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            new Expanded(
              child: new Container(
                padding: EdgeInsets.only(left: 15, top: 2),
                child: new Text(
                  data.niceDate,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(right: 10),
              child: new Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
