import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_bean.dart';
import 'package:wanandroid_learning_flutter/model/search_hot_key_bean.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchTeController = TextEditingController();
  List<HotKey> _hotKeyList = List();
  int _pageNumber = 0;
  List<Article> _searchArticleList = List();
  List<Widget> _hotKeyWidget = List();

  void _getSearchHotKey() {
    ApiService().getSearchHotKey((SearchHotKeyBean searchHotKeyBean) {
      var commentWidgets = List<Widget>();
      for (var hotKey in searchHotKeyBean.hotKey) {
        _hotKeyWidget.add(Chip(label: Text(hotKey.name)));
      }
      setState(() {});
//      setState(() {
//        _hotKeyList.addAll(searchHotKeyBean.hotKey);
//      });
    });
  }

  void _search(int pageNumber, String key) {
    ApiService().search(pageNumber, key, (ArticleBean articleBean) {
      setState(() {
        _searchArticleList.addAll(articleBean.data.articles);
      });
    });
  }

  @override
  void initState() {
    _searchTeController.addListener(() {});
    _getSearchHotKey();
    super.initState();
  }

  @override
  void dispose() {
    _searchTeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            color: Colors.blue,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 10,
                  bottom: 22,
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                  bottom: 15,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: TextField(
//                      onChanged: onChanged,
                      controller: _searchTeController,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      autofocus: false,
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '动画',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _searchTeController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
