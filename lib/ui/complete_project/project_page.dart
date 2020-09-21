import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/project_category_entity.dart';
import 'package:wanandroid_learning_flutter/ui/complete_project/complete_project_list_page.dart';
import 'package:wanandroid_learning_flutter/widget/MyCircularProgressIndicator.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  var _commentWidgets = List<Widget>();
  var _tabList = List<Tab>();
  var _tabBarView = List<Widget>();

  Future<ProjectCategoryEntity> _retrieveData() async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/project/tree/json");
      print(response);
      ProjectCategoryEntity projectCategoryEntity =
          JsonConvert.fromJsonAsT(response.data);
      _commentWidgets.clear();
      _tabList.clear();
      _tabBarView.clear();
      for (var projectCategoryData in projectCategoryEntity.data) {
        _tabList.add(Tab(text: projectCategoryData.name));
        _tabBarView.add(CompleteProjectListPage(projectCategoryData));
      }
      //刷新UI
      return projectCategoryEntity;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _retrieveData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
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
        } else {
          // 请求未结束，显示loading
          return MyCircularProgressIndicator();
        }
      },
    );
  }
}
