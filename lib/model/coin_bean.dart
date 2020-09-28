class CoinBean {
  Coin coin;
  int errorCode;
  String errorMsg;

  CoinBean({this.coin, this.errorCode, this.errorMsg});

  CoinBean.fromJson(Map<String, dynamic> json) {
    coin = json['data'] != null ? new Coin.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coin != null) {
      data['data'] = this.coin.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class Coin {
  int coinCount;
  int level;
  String rank;
  int userId;
  String username;

  Coin({this.coinCount, this.level, this.rank, this.userId, this.username});

  Coin.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'];
    level = json['level'];
    rank = json['rank'];
    userId = json['userId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinCount'] = this.coinCount;
    data['level'] = this.level;
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}
