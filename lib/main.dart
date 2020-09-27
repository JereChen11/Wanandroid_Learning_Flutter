import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/res/text_styles.dart';
import 'package:wanandroid_learning_flutter/page/home/home_page.dart';
import 'package:wanandroid_learning_flutter/page/knowledge_system/knowledge_system_page.dart';
import 'package:wanandroid_learning_flutter/page/me/me_page.dart';
import 'package:wanandroid_learning_flutter/page/project/project_page.dart';
import 'package:wanandroid_learning_flutter/page/we_chat/we_chat_page.dart';
import 'package:wanandroid_learning_flutter/res/colours.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
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
      title: Text(Strings.HOME_CN),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.PROJECT_CN),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.PROJECT_CN),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.KNOWLEDGE_SYSTEM_CN),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.ME_CN),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: _appBar[_currentIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: GestureDetector(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: SpUtil().getString(Constant.avatarPathTag) == null
                          ? CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/landscape.jpg"),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(SpUtil()
                                      .getString(Constant.avatarPathTag))),
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        SpUtil().getString(Constant.usernameTag) == null
                            ? "username"
                            : SpUtil().getString(Constant.usernameTag),
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onTap: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                image: new DecorationImage(
                    image: AssetImage("assets/images/landscape.jpg"),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: Text(
                Strings.HOME_CN,
                style: TextStyles.size18AndBoldText,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                Strings.PROJECT_CN,
                style: TextStyles.size18AndBoldText,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                Strings.WE_CHAT_CN,
                style: TextStyles.size18AndBoldText,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                Strings.KNOWLEDGE_SYSTEM_CN,
                style: TextStyles.size18AndBoldText,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                Strings.ME_CN,
                style: TextStyles.size18AndBoldText,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _currentIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.HOME_CN,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.PROJECT_CN,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.web,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.WE_CHAT_CN,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.live_tv,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.KNOWLEDGE_SYSTEM_CN,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.accessibility,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.ME_CN,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
        ],
        selectedItemColor: Colours.app_theme,
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
