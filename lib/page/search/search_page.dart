import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/search_hot_key_bean.dart';
import 'package:wanandroid_learning_flutter/page/search/search_result_page.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchTeController = TextEditingController();
  List<Widget> _hotKeyWidget = [];
  List<Widget> _localSearchHistoryWidgetList = [];

  void _getSearchHotKey() {
    ApiService().getSearchHotKey((SearchHotKeyBean searchHotKeyBean) {
      for (var hotKey in searchHotKeyBean.hotKey) {
        _hotKeyWidget.add(GestureDetector(
          child: Chip(label: Text(hotKey.name)),
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultPage(hotKey.name)))
                .then((value) => _getLocalSearchHistoryRecordData());
          },
        ));
      }
      setState(() {});
    });
  }

  void _getLocalSearchHistoryRecordData() {
    List<String> localSearchHistoryList =
        SpUtil().getStringList(Constant.localSearchHistoryKey);
    if (localSearchHistoryList == null) {
      return;
    }
    setState(() {
      _localSearchHistoryWidgetList.clear();
      for (var historySearchKey in localSearchHistoryList) {
        _localSearchHistoryWidgetList.add(GestureDetector(
          child: Chip(
            label: Text(historySearchKey),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResultPage(historySearchKey)));
          },
        ));
      }
    });
  }

  void _clearLocalSearchHistory() {
    SpUtil().remove(Constant.localSearchHistoryKey);
    setState(() {
      _localSearchHistoryWidgetList.clear();
    });
  }

  @override
  void initState() {
    _searchTeController.addListener(() {});
    _getSearchHotKey();
    _getLocalSearchHistoryRecordData();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                  bottom: 15,
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
                  bottom: 10,
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
                          Icons.text_fields,
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
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    iconSize: 35,
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      if (_searchTeController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "请先输入搜索内容", textColor: Colors.grey);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResultPage(
                                    _searchTeController.text))).then(
                            (value) => _getLocalSearchHistoryRecordData());
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          _searchHistoryWidget(),
          _hotSearchWidget(),
        ],
      ),
    );
  }

  Widget _searchHistoryWidget() {
    return Visibility(
      visible: _localSearchHistoryWidgetList.length == 0 ? false : true,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "搜索历史",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                IconButton(
                  alignment: Alignment.bottomRight,
                  icon: Icon(Icons.restore_from_trash),
                  onPressed: () {
                    _clearLocalSearchHistory();
                  },
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 15.0,
              runSpacing: 1.0,
              children: _localSearchHistoryWidgetList,
            )
          ],
        ),
      ),
    );
  }

  Widget _hotSearchWidget() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "热门搜索",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 15.0,
            runSpacing: 1.0,
            children: _hotKeyWidget,
          )
        ],
      ),
    );
  }
}
