import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/article_category_bean.dart';
import 'package:wanandroid_learning_flutter/page/project/project_article_list_page.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var _tabList = <Tab>[];
  var _tabBarView = <Widget>[];

  @override
  void initState() {
    _getProjectArticleCategoryData();
    super.initState();
  }

  void _getProjectArticleCategoryData() async {
    ApiService()
        .getProjectArticleCategory((ArticleCategoryBean articleCategoryBean) {
      setState(() {
        _tabList.clear();
        _tabBarView.clear();
        for (var projectCategoryData in articleCategoryBean.category) {
          _tabList.add(Tab(text: projectCategoryData.name));
          _tabBarView.add(ProjectArticleListPage(projectCategoryData.id));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabList.length == 0) {
      return Center(
        child: MyCircularProgressIndicator(),
      );
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
