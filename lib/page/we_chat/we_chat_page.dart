import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_category_bean.dart';
import 'package:wanandroid_learning_flutter/page/we_chat/we_chat_article_list_page.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

class WeChatPage extends StatefulWidget {
  @override
  _WeChatPageState createState() => _WeChatPageState();
}

class _WeChatPageState extends State<WeChatPage> {
  var _tabList = List<Tab>();
  var _tabBarView = List<Widget>();

  @override
  void initState() {
    _retrieveBloggerListData();
    super.initState();
  }

  void _retrieveBloggerListData() async {
    ApiService()
        .getWeChatArticleCategory((ArticleCategoryBean articleCategoryBean) {
      setState(() {
        _tabList.clear();
        _tabBarView.clear();
        for (var bloggerListData in articleCategoryBean.category) {
          _tabList.add(Tab(text: bloggerListData.name));
          _tabBarView.add(WeChatArticleListPage(bloggerListData.id));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabList.length == 0) {
      return MyCircularProgressIndicator();
    } else {
      return MaterialApp(
        home: DefaultTabController(
          length: _tabList.length,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                bottom: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  indicatorColor: Colors.white,
                  tabs: _tabList,
                ),
              ),
            ),
            body: TabBarView(
              children: _tabBarView,
            ),
          ),
        ),
      );
    }
  }
}
