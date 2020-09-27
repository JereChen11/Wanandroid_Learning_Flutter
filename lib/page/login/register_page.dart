import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/main.dart';
import 'package:wanandroid_learning_flutter/model/user_bean.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _isInputUsernameContent = false;
  bool _isInputPasswordContent = false;
  bool _isInputRePasswordContent = false;

  @override
  void initState() {
    _usernameController.addListener(() {
      setState(() {
        if (_usernameController.text.trim().isNotEmpty) {
          _isInputUsernameContent = true;
        } else {
          _isInputUsernameContent = false;
        }
      });
    });

    _passwordController.addListener(() {
      setState(() {
        if (_passwordController.text.trim().isNotEmpty) {
          _isInputPasswordContent = true;
        } else {
          _isInputPasswordContent = false;
        }
      });
    });

    _rePasswordController.addListener(() {
      setState(() {
        if (_rePasswordController.text.trim().isNotEmpty) {
          _isInputRePasswordContent = true;
        } else {
          _isInputRePasswordContent = false;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    var data = {
      "username": _usernameController.text,
      "password": _passwordController.text,
      "repassword": _rePasswordController.text,
    };
    ApiService().register(data, (UserBean userBean) {
      if (userBean.errorCode == 0) {
        SpUtil().putString(Constant.usernameTag, _usernameController.text);
        SpUtil().putBool(Constant.isLoginKey, true);
        Fluttertoast.showToast(msg: "注册成功：${userBean.data.username}");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
      } else {
        Fluttertoast.showToast(msg: "注册失败：${userBean.errorMsg}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
            image: AssetImage("assets/images/landscape.jpg"),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            title: Text("注册账号"),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 50, left: 25, right: 25),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名或邮箱",
                    prefixIcon: Icon(Icons.account_circle),
                    suffixIcon: Visibility(
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(1),
                        onPressed: () {
                          _usernameController.clear();
                        },
                      ),
                      visible: _isInputUsernameContent,
                    ),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "请输入密码",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Visibility(
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(1),
                        onPressed: () {
                          _passwordController.clear();
                        },
                      ),
                      visible: _isInputPasswordContent,
                    ),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _rePasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "确认密码",
                    hintText: "请再次确认密码",
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: Visibility(
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.all(1),
                        onPressed: () {
                          _rePasswordController.clear();
                        },
                      ),
                      visible: _isInputRePasswordContent,
                    ),
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                      child: Text("注册"),
                      color: Colors.white54,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        if (_isInputUsernameContent &&
                            _isInputPasswordContent &&
                            _isInputRePasswordContent) {
                          if (_passwordController.text ==
                              _rePasswordController.text) {
                            _register();
                          } else {
                            Fluttertoast.showToast(msg: "请检查两次输入的密码是否一致");
                          }
                        } else if (!_isInputUsernameContent) {
                          Fluttertoast.showToast(msg: "请输入用户名");
                        } else if (!_isInputPasswordContent) {
                          Fluttertoast.showToast(msg: "请输入密码");
                        } else if (!_isInputRePasswordContent) {
                          Fluttertoast.showToast(msg: "请确认密码");
                        }
                        //hide the keyboard
                        FocusScope.of(context).unfocus();
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
