import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';

class KnowledgeSystemEntity with JsonConvert<KnowledgeSystemEntity> {
  List<KnowledgeSystemData> data;
  int errorCode;
  String errorMsg;
}

class KnowledgeSystemData with JsonConvert<KnowledgeSystemData> {
  List<KnowledgeSystemDatachild> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;
}

class KnowledgeSystemDatachild with JsonConvert<KnowledgeSystemDatachild> {
  List<dynamic> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;
}
