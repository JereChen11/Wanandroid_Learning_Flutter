import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid_learning_flutter/ui/HomePage.dart';
import 'package:wanandroid_learning_flutter/ui/KnowledgeSystemPage.dart';
import 'package:wanandroid_learning_flutter/ui/MePage.dart';
import 'package:wanandroid_learning_flutter/ui/complete_project/project_page.dart';
import 'package:wanandroid_learning_flutter/ui/we_chat_page.dart';
import 'package:wanandroid_learning_flutter/utils/SpUtil.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil().init();

  //android 沉浸式状态栏
  if(Platform.isAndroid){
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: BottomNavigationWidget(),
    );
  }
}

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _bottomNavigationBarColor = Colors.white;
  final _bottomNavigationBarTitleColor = Colors.white;
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    ProjectPage(),
    WeChatPage(),
    KnowledgeSystemPage(),
    MePage(),
  ];

  final List<Widget> _appBar = [
    AppBar(
      centerTitle: true,
      title: Text("主页"),
    ),
    AppBar(
      centerTitle: true,
      title: Text("完整项目"),
    ),
    AppBar(
      centerTitle: true,
      title: Text("微信公众号"),
    ),
    AppBar(
      centerTitle: true,
      title: Text("知识体系"),
    ),
    AppBar(
      centerTitle: true,
      title: Text("我的"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _appBar[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              "主页",
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              "完整项目",
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.web,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              "微信公众号",
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.live_tv,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              "知识体系",
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.accessibility,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              "我的",
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[400],
      ),
      body: _children[_currentIndex],
    );
  }
}
