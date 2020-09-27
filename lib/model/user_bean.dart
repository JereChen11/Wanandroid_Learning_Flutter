class UserBean {
  User data;
  int errorCode;
  String errorMsg;

  UserBean({this.data, this.errorCode, this.errorMsg});

  UserBean.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new User.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class User {
  bool admin;
//  List<Null> chapterTops;
  int coinCount;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String publicName;
  String token;
  int type;
  String username;

  User(
      {this.admin,
//        this.chapterTops,
      this.coinCount,
      this.collectIds,
      this.email,
      this.icon,
      this.id,
      this.nickname,
      this.password,
      this.publicName,
      this.token,
      this.type,
      this.username});

  User.fromJson(Map<String, dynamic> json) {
    admin = json['admin'];
//    if (json['chapterTops'] != null) {
//      chapterTops = new List<Null>();
//      json['chapterTops'].forEach((v) {
//        chapterTops.add(new Null.fromJson(v));
//      });
//    }
    coinCount = json['coinCount'];
    collectIds = json['collectIds'].cast<int>();
    email = json['email'];
    icon = json['icon'];
    id = json['id'];
    nickname = json['nickname'];
    password = json['password'];
    publicName = json['publicName'];
    token = json['token'];
    type = json['type'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin'] = this.admin;
//    if (this.chapterTops != null) {
//      data['chapterTops'] = this.chapterTops.map((v) => v.toJson()).toList();
//    }
    data['coinCount'] = this.coinCount;
    data['collectIds'] = this.collectIds;
    data['email'] = this.email;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['publicName'] = this.publicName;
    data['token'] = this.token;
    data['type'] = this.type;
    data['username'] = this.username;
    return data;
  }
}
