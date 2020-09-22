import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/blogger_list_entity.dart';
import 'package:wanandroid_learning_flutter/ui/we_chat/we_chat_list_page.dart';
import 'package:wanandroid_learning_flutter/widget/MyCircularProgressIndicator.dart';

class WeChatPage extends StatefulWidget {
  @override
  _WeChatPageState createState() => _WeChatPageState();
}

class _WeChatPageState extends State<WeChatPage> {
  var _tabList = List<Tab>();
  var _tabBarView = List<Widget>();

  Future<BloggerListEntity> _retrieveBloggerListData() async {
    try {
      Response response =
          await Dio().get("https://wanandroid.com/wxarticle/chapters/json");
      print(response);
      BloggerListEntity bloggerListEntity =
          JsonConvert.fromJsonAsT(response.data);
      _tabList.clear();
      _tabBarView.clear();
      for (var bloggerListData in bloggerListEntity.data) {
        _tabList.add(Tab(text: bloggerListData.name));
        _tabBarView.add(WeChatListPage(bloggerListData.id));
      }
      return bloggerListEntity;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _retrieveBloggerListData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
            return MaterialApp(
              home: DefaultTabController(
                length: _tabList.length,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: AppBar(
                      bottom: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.white.withOpacity(0.5),
                        indicatorColor: Colors.white,
                        tabs: _tabList,
                      ),
                    ),
                  ),
                  body: TabBarView(
                    children: _tabBarView,
                  ),
                ),
              ),
            );
          }
        } else {
          // 请求未结束，显示loading
          return MyCircularProgressIndicator();
        }
      },
    );
  }
}
