import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/res/text_styles.dart';
import 'package:wanandroid_learning_flutter/ui/HomePage.dart';
import 'package:wanandroid_learning_flutter/ui/knowledge_system_page.dart';
import 'package:wanandroid_learning_flutter/ui/MePage.dart';
import 'package:wanandroid_learning_flutter/ui/complete_project/project_page.dart';
import 'package:wanandroid_learning_flutter/ui/we_chat_page.dart';
import 'package:wanandroid_learning_flutter/res/colours.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

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
      title: Text(Strings.home_cn),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.complete_project_cn),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.complete_project_cn),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.knowledge_system_cn),
    ),
    AppBar(
      centerTitle: true,
      title: Text(Strings.me_cn),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _appBar[_currentIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: new GestureDetector(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(top: 10),
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
                    new Padding(
                      padding: EdgeInsets.only(top: 10),
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
                color: Colours.app_theme,
              ),
            ),
            ListTile(
              title: Text(
                Strings.home_cn,
                style: TextStyles.size18AndBoldText,
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
                Strings.complete_project_cn,
                style: TextStyles.size18AndBoldText,
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
                Strings.we_chat_cn,
                style: TextStyles.size18AndBoldText,
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
                Strings.knowledge_system_cn,
                style: TextStyles.size18AndBoldText,
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
                Strings.me_cn,
                style: TextStyles.size18AndBoldText,
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
              Strings.home_cn,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.complete_project_cn,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.web,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.we_chat_cn,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.live_tv,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.knowledge_system_cn,
              style: TextStyle(color: _bottomNavigationBarTitleColor),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.accessibility,
              color: _bottomNavigationBarColor,
            ),
            title: Text(
              Strings.me_cn,
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
