import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/project_category_entity.dart';
import 'package:wanandroid_learning_flutter/ui/completeproject/CompleteProjectListPage.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ProjectCategoryWidget(),
    );
  }
}

class ProjectCategoryWidget extends StatefulWidget {
  @override
  _ProjectCategoryState createState() => _ProjectCategoryState();
}

class _ProjectCategoryState extends State<ProjectCategoryWidget> {
  var _commentWidgets = List<Widget>();

  void _retrieveData() async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/project/tree/json");
      print(response);
      ProjectCategoryEntity projectCategoryEntity =
          JsonConvert.fromJsonAsT(response.data);
      _commentWidgets.clear();
      for (var projectCategoryData in projectCategoryEntity.data) {
        _commentWidgets.add(RaisedButton(
          color: Colors.blue,
          highlightColor: Colors.blue[700],
          colorBrightness: Brightness.dark,
          splashColor: Colors.white,
          child: Text(projectCategoryData.name),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {
            print("jereTest: ${projectCategoryData.name}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CompleteProjectListPage(projectCategoryData.id)));
          },
        ));
      }
      //刷新UI
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _retrieveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      spacing: 2,
      runSpacing: 2,
      alignment: WrapAlignment.center,
      children: _commentWidgets,
    );
  }
}
