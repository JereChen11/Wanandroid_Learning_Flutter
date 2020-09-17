import 'package:wanandroid_learning_flutter/model/login_entity.dart';

loginEntityFromJson(LoginEntity data, Map<String, dynamic> json) {
  if (json['data'] != null) {
    data.data = new LoginData().fromJson(json['data']);
  }
  if (json['errorCode'] != null) {
    data.errorCode = json['errorCode']?.toInt();
  }
  if (json['errorMsg'] != null) {
    data.errorMsg = json['errorMsg']?.toString();
  }
  return data;
}

Map<String, dynamic> loginEntityToJson(LoginEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.data != null) {
    data['data'] = entity.data.toJson();
  }
  data['errorCode'] = entity.errorCode;
  data['errorMsg'] = entity.errorMsg;
  return data;
}

loginDataFromJson(LoginData data, Map<String, dynamic> json) {
  if (json['admin'] != null) {
    data.admin = json['admin'];
  }
  if (json['chapterTops'] != null) {
    data.chapterTops = new List<dynamic>();
    data.chapterTops.addAll(json['chapterTops']);
  }
  if (json['coinCount'] != null) {
    data.coinCount = json['coinCount']?.toInt();
  }
  if (json['collectIds'] != null) {
    data.collectIds =
        json['collectIds']?.map((v) => v?.toInt())?.toList()?.cast<int>();
  }
  if (json['email'] != null) {
    data.email = json['email']?.toString();
  }
  if (json['icon'] != null) {
    data.icon = json['icon']?.toString();
  }
  if (json['id'] != null) {
    data.id = json['id']?.toInt();
  }
  if (json['nickname'] != null) {
    data.nickname = json['nickname']?.toString();
  }
  if (json['password'] != null) {
    data.password = json['password']?.toString();
  }
  if (json['publicName'] != null) {
    data.publicName = json['publicName']?.toString();
  }
  if (json['token'] != null) {
    data.token = json['token']?.toString();
  }
  if (json['type'] != null) {
    data.type = json['type']?.toInt();
  }
  if (json['username'] != null) {
    data.username = json['username']?.toString();
  }
  return data;
}

Map<String, dynamic> loginDataToJson(LoginData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['admin'] = entity.admin;
  if (entity.chapterTops != null) {
    data['chapterTops'] = [];
  }
  data['coinCount'] = entity.coinCount;
  data['collectIds'] = entity.collectIds;
  data['email'] = entity.email;
  data['icon'] = entity.icon;
  data['id'] = entity.id;
  data['nickname'] = entity.nickname;
  data['password'] = entity.password;
  data['publicName'] = entity.publicName;
  data['token'] = entity.token;
  data['type'] = entity.type;
  data['username'] = entity.username;
  return data;
}
