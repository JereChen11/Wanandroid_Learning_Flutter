import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';

class ProjectCategoryEntity with JsonConvert<ProjectCategoryEntity> {
  List<ProjectCategoryData> data;
  int errorCode;
  String errorMsg;
}

class ProjectCategoryData with JsonConvert<ProjectCategoryData> {
  List<dynamic> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;
}
