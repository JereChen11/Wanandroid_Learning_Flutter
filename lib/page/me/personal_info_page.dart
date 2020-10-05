import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/coin_bean.dart';
import 'package:wanandroid_learning_flutter/page/me/coin/coin_rank_list_page.dart';
import 'package:wanandroid_learning_flutter/page/me/coin/personal_coin_list_page.dart';
import 'package:wanandroid_learning_flutter/res/strings.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String username = (SpUtil().getString(Constant.usernameTag) == null)
      ? Strings.AVATAR_CN
      : SpUtil().getString(Constant.usernameTag);
  File _image;
  Coin _coin;

  @override
  void initState() {
    String avatarPath = SpUtil().getString(Constant.avatarPathTag);
    if (avatarPath != null) {
      _image = File(avatarPath);
    }
    _getPersonalCoinData();
    super.initState();
  }

  void _getPersonalCoinData() {
    ApiService().getPersonalCoinData((CoinBean coinBean) {
      setState(() {
        _coin = coinBean.coin;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.PERSONAL_INFO_CN),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Strings.AVATAR_CN,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 60,
                    height: 60,
                    child: _image == null
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/landscape.jpg"),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(_image)))),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            onTap: () {
              _showChangeAvatarDialog(context);
            },
          ),
          _divideLine(),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Strings.USER_NAME_CN,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(username ?? Strings.USER_NAME_CN),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            onTap: () {
              Fluttertoast.showToast(
                  msg: Strings.NO_SUPPORT_CHANGE_USER_NAME_CN,
                  textColor: Colors.grey);
            },
          ),
          _divideLine(),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Strings.TOTAL_COIN_CN,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(_coin == null ? "" : _coin.coinCount.toString()),
                ),
              ],
            ),
          ),
          _divideLine(),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Strings.CURRENT_RANK_CN,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(_coin == null ? "" : _coin.rank),
                ),
              ],
            ),
          ),
          _divideLine(),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Strings.CURRENT_LEVEL_CN,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(_coin == null ? "" : _coin.level.toString()),
                ),
              ],
            ),
          ),
          _divideLine(),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Strings.COIN_LIST_CN,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalCoinListPage()));
            },
          ),
          _divideLine(),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      Strings.COIN_RANK_CN,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CoinRankListPage()));
            },
          ),
          _divideLine(),
        ],
      ),
    );
  }

  Widget _divideLine() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 1,
      color: Colors.grey,
    );
  }

  @deprecated
  Future<String> _showChangeUsernameDialog() {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("请输入新的用户名"),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText:
                  SpUtil().getString(Constant.usernameTag).toString().isEmpty
                      ? Strings.USER_NAME_CN
                      : SpUtil().getString(Constant.usernameTag),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                SpUtil().putString(Constant.usernameTag, _controller.text);
                //关闭对话框并返回true
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangeAvatarDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(Strings.PLS_SELECT_PICTURE_CN),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(Strings.GALLERY_CN),
                      onTap: () {
                        _openGallery();
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(Strings.CAMERA_CN),
                      ),
                      onTap: () {
                        _openCamera();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  _openGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    SpUtil().putString(Constant.avatarPathTag, pickedFile.path);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  _openCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    SpUtil().putString(Constant.avatarPathTag, pickedFile.path);

    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
