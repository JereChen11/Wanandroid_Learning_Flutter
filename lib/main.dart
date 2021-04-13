import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid_learning_flutter/page/home/home_page.dart';
import 'package:wanandroid_learning_flutter/page/knowledge_system/knowledge_system_page.dart';
import 'package:wanandroid_learning_flutter/page/me/me_page.dart';
import 'package:wanandroid_learning_flutter/page/project/project_page.dart';
import 'package:wanandroid_learning_flutter/page/we_chat/we_chat_page.dart';
import 'package:wanandroid_learning_flutter/res/colours.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil().init();

  //android 沉浸式状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanAnd_Flu',
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
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    ProjectPage(),
    WeChatPage(),
    KnowledgeSystemPage(),
    MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: Strings.HOME_CN,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
            ),
            label: Strings.PROJECT_CN,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: Strings.WE_CHAT_CN,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_system_daydream,
            ),
            label: Strings.KNOWLEDGE_SYSTEM_CN,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.accessibility,
            ),
            label: Strings.ME_CN,
          ),
        ],
        selectedItemColor: Colours.app_theme.withOpacity(0.5),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colours.app_theme),
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
