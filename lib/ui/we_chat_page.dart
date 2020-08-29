import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/blogger_list_entity.dart';
import 'package:wanandroid_learning_flutter/model/home_article_entity.dart';

class WeChatPage extends StatefulWidget {
  @override
  _WeChatPageState createState() => _WeChatPageState();
}

class _WeChatPageState extends State<WeChatPage> {
  List<HomeArticleDataData> _articleList = List();
  int _currentBloggerId = 408; //鸿洋
  bool _isLoadAllArticles = false;

  @override
  void initState() {
    _retrieveArticleListData(0, _currentBloggerId);
    super.initState();
  }

  void _retrieveArticleListData(int pageNumber, int bloggerId) {
    Future<HomeArticleEntity> articleEntityFuture =
        getArticleListData(pageNumber, bloggerId);

    articleEntityFuture.then((value) => {
          if (value.errorCode == 0 && value.data.datas.length > 0)
            {
              setState(() {
                _articleList.clear();
                _articleList.addAll(value.data.datas);
                _isLoadAllArticles = false;
              })
            }
          else
            {
              setState(() {
                _isLoadAllArticles = true;
                print("jeretest _isLoadAllArticles = $_isLoadAllArticles");
              })
            }
        });
  }

  Future<HomeArticleEntity> getArticleListData(
      int pageNumber, int bloggerId) async {
    try {
      Response response = await Dio().get(
          "https://wanandroid.com/wxarticle/list/$bloggerId/$pageNumber/json");
      print("getArticleListData = $response");
      HomeArticleEntity articleEntity = JsonConvert.fromJsonAsT(response.data);
      return articleEntity;
    } catch (e) {
      print(e);
    }
  }

  void _loadMoreData(int pageNumber, int bloggerId) {
    Future<HomeArticleEntity> articleEntityFuture =
        getArticleListData(pageNumber, bloggerId);
    articleEntityFuture.then((value) => {
          if (value.errorCode == 0 && value.data.datas.length > 0)
            {
              setState(() {
                _articleList.addAll(value.data.datas);
                _isLoadAllArticles = false;
              })
            }
          else
            {
              setState(() {
                _isLoadAllArticles = true;
                print("jeretest _isLoadAllArticles = $_isLoadAllArticles");
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    print("_WeChatPageState build isLoadAllArticles = $_isLoadAllArticles");
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: BloggerList(
            onSelectedChange: (int bloggerId) {
              print("WeChatPage onSelectedChange bloggerId = $bloggerId");
              _currentBloggerId = bloggerId;
              _retrieveArticleListData(0, bloggerId);
            },
          ),
        ),
        new Expanded(
          child: BlogArticleList(
            loadMoreData: (int pageNumber) {
              print("loadMoreData pageNumber = $pageNumber");
              _loadMoreData(pageNumber, _currentBloggerId);
            },
            articleList: _articleList,
            isLoadAllArticles: _isLoadAllArticles,
          ),
        ),
      ],
    );
  }
}

class BloggerList extends StatefulWidget {
  final Function(int) onSelectedChange;
  List<BloggerListData> bloggerList = List();

  BloggerList({Key key, this.onSelectedChange}) : super(key: key);

  @override
  _BloggerListSate createState() => _BloggerListSate(onSelectedChange);
}

class _BloggerListSate extends State<BloggerList> {
  List<BloggerListData> _bloggerList = List();
  bool _isLoadAllBloggerData = false;
  int _selectedIndex = 0;

  Function(int) onSelectedChange;

  _BloggerListSate(Function(int) onSelectedChange) {
    this.onSelectedChange = onSelectedChange;
    print("BloggerList length = $_bloggerList.length");
  }

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
                onSelectedChange(_bloggerList[index].id);
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
                            color: (index == _selectedIndex)
                                ? Colors.blue
                                : Colors.transparent,
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

class BlogArticleList extends StatefulWidget {
  final Function(int) loadMoreData;
  List<HomeArticleDataData> articleList = List();
  bool isLoadAllArticles;

  BlogArticleList(
      {Key key, this.loadMoreData, this.articleList, this.isLoadAllArticles})
      : super(key: key);

  @override
  _BlogArticleListState createState() =>
      _BlogArticleListState(loadMoreData, articleList, isLoadAllArticles);
}

class _BlogArticleListState extends State<BlogArticleList> {
  Function(int) loadMoreData;
  List<HomeArticleDataData> articleList = List();
  IconData _isCollectedIcon = Icons.favorite;
  int _pageNumber = 0;
  bool isLoadAllArticles;

  _BlogArticleListState(Function(int) loadMoreData,
      List<HomeArticleDataData> articleList, bool isLoadAllArticles) {
    this.loadMoreData = loadMoreData;
    this.articleList = articleList;
    this.isLoadAllArticles = isLoadAllArticles;
  }

  @override
  void initState() {
    print("jereTest _BlogArticleListState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("jereTest _BlogArticleListState build");
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: articleList.length,
      itemBuilder: (context, index) {
        if (index == articleList.length - 1) {
          //加载了所有数据后，不必再去请求服务器，这时候也不应该展示 loading, 而是展示"所有文章都已被加载"
          loadMoreData(_pageNumber++);

          return Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: new Column(
              children: <Widget>[
                new Visibility(
                  child: new SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  visible: !isLoadAllArticles,
                ),
                new Visibility(
                  child: Text(
                    "所有文章都已被加载",
                  ),
                  visible: isLoadAllArticles,
                )
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
                      articleList[index].title,
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
                              articleList[index].author.isEmpty
                                  ? articleList[index].shareUser
                                  : articleList[index].author,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          )),
                      new Expanded(
                        child: new Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          child: new Text(
                            articleList[index].niceDate,
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
