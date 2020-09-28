import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/coin_list_bean.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/widget/my_circular_progress_indicator.dart';

class PersonalCoinListPage extends StatefulWidget {
  @override
  _PersonalCoinListPageState createState() => _PersonalCoinListPageState();
}

class _PersonalCoinListPageState extends State<PersonalCoinListPage> {
  List<CoinOrigin> _coinOriginList = List();
  int _pageNumber = 0;
  bool _isLoadAllCoinOriginData = false;

  void _getPersonalCoinListData(int pageNumber) {
    ApiService().getPersonalCoinListData(pageNumber,
        (CoinListBean coinListBean) {
      setState(() {
        if (coinListBean.data != null) {
          _isLoadAllCoinOriginData = coinListBean.data.over;
          _coinOriginList.addAll(coinListBean.data.coinOrigins);
        }
        if (_isLoadAllCoinOriginData) {
          _coinOriginList.add(null); //用于展示到底啦～
        }
      });
    });
  }

  @override
  void initState() {
    _getPersonalCoinListData(_pageNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.PERSONAL_COIN_LIST_CN),
      ),
      body: (_coinOriginList.length == 0)
          ? Center(
              child: MyCircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                if (index == _coinOriginList.length - 1) {
                  //加载了所有数据后，不必再去请求服务器，这时候也不应该展示 loading, 而是展示"所有文章都已被加载"
                  if (!_isLoadAllCoinOriginData) {
                    _getPersonalCoinListData(++_pageNumber);
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

                return _coinListItem(_coinOriginList[index]);
              },
              itemCount: _coinOriginList.length,
            ),
    );
  }

  Widget _coinListItem(CoinOrigin coinOrigin) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(coinOrigin.desc),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
