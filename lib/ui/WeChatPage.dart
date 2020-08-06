import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/blogger_list_entity.dart';
import 'package:wanandroid_learning_flutter/model/home_article_entity.dart';

class WeChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: _BloggerList(),
        ),
        new Expanded(
          child: _BlogArticleList(),
        ),
      ],
    );
  }
}

class _BloggerList extends StatefulWidget {
  @override
  _BloggerListSate createState() => _BloggerListSate();
}

class _BloggerListSate extends State<_BloggerList> {
  List<BloggerListData> _bloggerList = List();
  bool _isLoadAllBloggerData = false;
  int _selectedIndex = 0;

  void _retrieveBloggerListData() async {
    try {
      Response response =
          await Dio().get("https://wanandroid.com/wxarticle/chapters/json");
      print(response);
      BloggerListEntity bloggerListEntity =
          JsonConvert.fromJsonAsT(response.data);
      if (bloggerListEntity.errorCode == 0) {
        _bloggerList.clear();
        _bloggerList.addAll(bloggerListEntity.data);
        _isLoadAllBloggerData = true;
        //刷新UI
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _retrieveBloggerListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _bloggerList.length,
      itemBuilder: (context, index) {
        if (!_isLoadAllBloggerData) {
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
          child: new Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 4.0, bottom: 10.0),
            child: new InkWell(
              highlightColor: Colors.blue,
              splashColor: Colors.grey,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                print("jeretest gestureDetector ontap: $index");
                print("jeretest onTap _blogId = ${_bloggerList[index].id}");
                _BlogArticleListState(_bloggerList[index].id);
              },
              child: new Container(
                alignment: Alignment.center,
                width: 120.0,
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: new Text(
                        _bloggerList[index].name,
                        style: new TextStyle(color: const Color(0xFF273A48)),
                      ),
                    ),
                    new Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            width: 100,
                            height: 3,
                            color: (index == _selectedIndex) ? Colors.blue : Colors.transparent,
                            alignment: Alignment.bottomCenter,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BlogArticleList extends StatefulWidget {
  @override
  _BlogArticleListState createState() => _BlogArticleListState(408);
}

class _BlogArticleListState extends State<_BlogArticleList> {
  List<HomeArticleDataData> _articleList = List();
  IconData _isCollectedIcon = Icons.favorite;
  int _pageNumber = 0;
  int _bloggerId = 408; //default value is 鸿洋

  void refreshUi(int blogId) {
    this._bloggerId = blogId;
    _retrieveArticleListData(blogId);
  }

  _BlogArticleListState(int blogId) {
    this._bloggerId = blogId;
    print("jeretest _blogId = $_bloggerId");
  }

  void _retrieveArticleListData(int blogId) async {
    try {
      Response response = await Dio().get(
          "https://wanandroid.com/wxarticle/list/$_bloggerId/$_pageNumber/json");
      print("retrieve article List dtaa = $response");
      HomeArticleEntity articleEntity = JsonConvert.fromJsonAsT(response.data);
      if (articleEntity.errorCode == 0) {
        _articleList.addAll(articleEntity.data.datas);
        _pageNumber++;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print("jereTest _BlogArticleListState");
    _retrieveArticleListData(_bloggerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("jereTest _BlogArticleListState build");
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _articleList.length,
      itemBuilder: (context, index) {
        if (index == _articleList.length - 1) {
          //加载了所有数据后，不必再去请求服务器，这时候也不应该展示 loading, 而是展示"所有文章都已被加载"
          _retrieveArticleListData(_bloggerId);
          return Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          );
        }

        return new GestureDetector(
            onTap: () {
              print("blogArticleList onTap $index");
            },
            child: new Container(
              color: Colors.transparent,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(left: 10, top: 12, bottom: 10),
                    child: new Text(
                      _articleList[index].title,
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
                              _articleList[index].author.isEmpty
                                  ? _articleList[index].shareUser
                                  : _articleList[index].author,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          )),
                      new Expanded(
                        child: new Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: new Text(
                            _articleList[index].niceDate,
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
              ),
            ));
      },
    );
  }
}
