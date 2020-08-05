import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/home_article_entity.dart';
import 'package:wanandroid_learning_flutter/ui/BrowserWebView.dart';

class CompleteProjectListPage extends StatefulWidget {
  int _projectId;

  CompleteProjectListPage(int projectId) {
    this._projectId = projectId;
  }

  @override
  _CompleteProjectListPageState createState() =>
      _CompleteProjectListPageState(_projectId);
}

class _CompleteProjectListPageState extends State<CompleteProjectListPage> {
  List<HomeArticleDataData> _articleData = List();
  int _projectId;
  int _pageNumber = 0;
  bool _isNotLoadAllData = true;

  _CompleteProjectListPageState(int projectId) {
    this._projectId = projectId;
  }

  void _retrieveArticleData(int pageNumber, int projectId) async {
    try {
      print("jereTest: pageNumber = $pageNumber, projectId = $projectId");
      Response response = await Dio().get(
          "https://www.wanandroid.com/project/list/$pageNumber/json?cid=$projectId");
      print(response);
      HomeArticleEntity homeArticleEntity =
          JsonConvert.fromJsonAsT(response.data);
      if (homeArticleEntity.errorCode == 0 &&
          homeArticleEntity.data.datas.length > 0) {
        _pageNumber++;
        _articleData.addAll(homeArticleEntity.data.datas);
        setState(() {});
      } else {
        setState(() {
          _isNotLoadAllData = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _retrieveArticleData(_pageNumber, _projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("完整项目列表"),
      ),
      body: ListView.builder(
        itemCount: _articleData.length,
        itemBuilder: (context, index) {
          if (index == _articleData.length - 1) {
            //加载了所有数据后，不必再去请求服务器，这时候也不应该展示 loading, 而是展示"所有文章都已被加载"
            if (_isNotLoadAllData) {
              _retrieveArticleData(_pageNumber, _projectId);
            }
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    width: 20,
                    height: 20,
                    child: new Visibility(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      visible: _isNotLoadAllData,
                    ),
                  ),
                  new Visibility(
                    child: Text(
                      "所有文章都已被加载",
                    ),
                    visible: !_isNotLoadAllData,
                  ),
                ],
              ),
            );
          }

          return new GestureDetector(
            child: _ListItemWidget(_articleData[index]),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BrowserWebView(_articleData[index].link)));
            },
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }
}

class _ListItemWidget extends StatefulWidget {
  HomeArticleDataData _data;

  _ListItemWidget(HomeArticleDataData data) {
    this._data = data;
  }

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState(_data);
}

class _ListItemWidgetState extends State<_ListItemWidget> {
  HomeArticleDataData _data;

  _ListItemWidgetState(HomeArticleDataData data) {
    this._data = data;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Image(
            image: NetworkImage(_data.envelopePic),
            width: 110,
            height: 200,
            alignment: Alignment.center,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 5, bottom: 5),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _data.title,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      height: 130,
                      child: Text(
                        _data.desc,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          _data.author,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new Expanded(
                          child: new Container(
                            child: Text(_data.niceDate),
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
