import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/user_bean.dart';
import 'package:wanandroid_learning_flutter/page/login/login_page.dart';
import 'package:wanandroid_learning_flutter/page/me/personal_info_page.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  String _isLoginStatus;

  void _reformatLoginStatus() {
    setState(() {
      if (SpUtil().getBool(Constant.isLoginKey) == null ||
          !SpUtil().getBool(Constant.isLoginKey)) {
        _isLoginStatus = Strings.LOGIN_CN;
      } else {
        _isLoginStatus = Strings.LOGOUT_CN;
      }
    });
  }

  @override
  void initState() {
    _reformatLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                      image: AssetImage("assets/images/landscape.jpg"),
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.dstATop),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 50,
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: SpUtil().getString(Constant.avatarPathTag) ==
                                null
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
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          SpUtil().getString(Constant.usernameTag) == null
                              ? Strings.USER_NAME_CN
                              : SpUtil().getString(Constant.usernameTag),
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.only(top: 10),
                      )
                    ],
                  ),
                  onTap: () {
                    if (SpUtil().getBool(Constant.isLoginKey) == null ||
                        !SpUtil().getBool(Constant.isLoginKey)) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalInfoPage()))
                          .then((value) => {_reformatLoginStatus()});
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
              child: _mePageItem(Icons.person, _isLoginStatus),
              onTap: () {
                if (SpUtil().getBool(Constant.isLoginKey) == null ||
                    !SpUtil().getBool(Constant.isLoginKey)) {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                      .then((value) => {
                            if (value == "loginSuccessful")
                              _reformatLoginStatus(),
                          });
                } else {
                  SpUtil().putBool(Constant.isLoginKey, false);
                  SpUtil().remove(Constant.usernameTag);
                  SpUtil().remove(Constant.avatarPathTag);
                  SpUtil().remove(Constant.cookieListKey);
                  ApiService().logout((UserBean userBean) {
                    if (userBean.errorCode == 0) {
                      Fluttertoast.showToast(
                          msg: Strings.QUIT_LOGIN_CN, textColor: Colors.grey);
                      _reformatLoginStatus();
                    }
                  });
                }
              })
        ],
      ),
    );
  }

  Widget _mePageItem(IconData iconData, String type) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, left: 15),
            child: Icon(
              iconData,
              size: 30,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
              child: Text(
                type,
                style: TextStyle(fontSize: 20, color: Colors.black38),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, right: 15),
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
