import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/project_category_entity.dart';
import 'package:wanandroid_learning_flutter/ui/search_page.dart';

class KnowledgeSystemPage extends StatefulWidget {
  @override
  _KnowledgeSystemPageState createState() => _KnowledgeSystemPageState();
}

class _KnowledgeSystemPageState extends State<KnowledgeSystemPage> {
  List<ProjectCategoryData> projectCategoryDataList = List();

  Future<ProjectCategoryEntity> _retrieveData() async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/project/tree/json");
      print(response);
      ProjectCategoryEntity projectCategoryEntity =
          JsonConvert.fromJsonAsT(response.data);
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
    return new Center(
        child: FutureBuilder(
      future: _retrieveData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            ProjectCategoryEntity projectCategoryEntity = snapshot.data;
            // 请求成功，显示数据
            return RaisedButton(
              child: Text("KnowledgeSystemPage",
                  style:
                      TextStyle(fontSize: 15, color: Colors.deepPurpleAccent)),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchPage(projectCategoryEntity.data));
              },
            );
          }
        } else {
          // 请求未结束，显示loading
          return CircularProgressIndicator();
        }
      },
    ));
  }
}
