import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/coin_rank_bean.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

class CoinRankListPage extends StatefulWidget {
  @override
  _CoinRankListPageState createState() => _CoinRankListPageState();
}

class _CoinRankListPageState extends State<CoinRankListPage> {
  List<Rank> _coinRankList = List();

  //start from 1
  int _pageNumber = 1;
  bool _isLoadAllCoinRank = false;

  void _getCoinRankData(int pageNumber) {
    ApiService().getCoinRankData(pageNumber, (CoinRankBean coinRankBean) {
      setState(() {
        if (coinRankBean.data != null) {
          _isLoadAllCoinRank = coinRankBean.data.over;
          _coinRankList.addAll(coinRankBean.data.ranks);
        }
        if (_isLoadAllCoinRank) {
          _coinRankList.add(null); //用于展示到底啦～
        }
      });
    });
  }

  @override
  void initState() {
    _getCoinRankData(_pageNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.COIN_RANK_CN),
      ),
      body: (_coinRankList.length == 0)
          ? Center(
              child: MyCircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                if (index == _coinRankList.length - 1) {
                  //加载了所有数据后，不必再去请求服务器，这时候也不应该展示 loading, 而是展示"所有文章都已被加载"
                  if (!_isLoadAllCoinRank) {
                    _getCoinRankData(++_pageNumber);
                    return MyCircularProgressIndicator();
                  } else {
                    return Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text(
                        Strings.GET_BOTTOM_CN,
                      ),
                    );
                  }
                }

                return _coinRankListItem(_coinRankList[index]);
              },
              itemCount: _coinRankList.length,
            ),
    );
  }

  Widget _coinRankListItem(Rank rank) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  "第 ${rank.rank} 名",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(rank.username,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text("${rank.level} 级", textAlign: TextAlign.center),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
