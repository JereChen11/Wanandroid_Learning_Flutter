import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';

class BloggerListEntity with JsonConvert<BloggerListEntity> {
	List<BloggerListData> data;
	int errorCode;
	String errorMsg;
}

class BloggerListData with JsonConvert<BloggerListData> {
	List<dynamic> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}
