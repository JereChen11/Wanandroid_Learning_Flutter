import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/model/project_category_entity.dart';
import 'package:wanandroid_learning_flutter/ui/browser_web_view_page.dart';

class CompleteProjectListPage extends StatefulWidget {
  ProjectCategoryData _projectCategoryData;

  CompleteProjectListPage(ProjectCategoryData projectCategoryData) {
    this._projectCategoryData = projectCategoryData;
  }

  @override
  _CompleteProjectListPageState createState() =>
      _CompleteProjectListPageState(_projectCategoryData);
}

class _CompleteProjectListPageState extends State<CompleteProjectListPage> {
  List<Article> _articleData = List();
  ProjectCategoryData _projectCategoryData;
  int _pageNumber = 0;
  bool _isNotLoadAllData = true;

  _CompleteProjectListPageState(ProjectCategoryData projectCategoryData) {
    this._projectCategoryData = projectCategoryData;
  }

  void _retrieveArticleData(int pageNumber, int projectId) async {
    try {
      print("jereTest: pageNumber = $pageNumber, projectId = $projectId");
      Response response = await Dio().get(
          "https://www.wanandroid.com/project/list/$pageNumber/json?cid=$projectId");
      print(response);
      ArticleBean articleBean = ArticleBean.fromJson(response.data);
      if (articleBean.errorCode == 0 && articleBean.data.articles.length > 0) {
        _pageNumber++;
        _articleData.addAll(articleBean.data.articles);
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
    _retrieveArticleData(_pageNumber, _projectCategoryData.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _articleData.length,
        itemBuilder: (context, index) {
          if (index == _articleData.length - 1) {
            //加载了所有数据后，不必再去请求服务器，这时候也不应该展示 loading, 而是展示"所有文章都已被加载"
            if (_isNotLoadAllData) {
              _retrieveArticleData(_pageNumber, _projectCategoryData.id);
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
                          BrowserWebViewPage(_articleData[index].link)));
            },
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }
}

class _ListItemWidget extends StatefulWidget {
  Article _article;

  _ListItemWidget(this._article);

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState(_article);
}

class _ListItemWidgetState extends State<_ListItemWidget> {
  Article _article;

  _ListItemWidgetState(this._article);

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
            image: NetworkImage(_article.envelopePic),
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
                    _article.title,
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
                        _article.desc,
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
                          _article.author,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new Expanded(
                          child: new Container(
                            child: Text(_article.niceDate),
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
