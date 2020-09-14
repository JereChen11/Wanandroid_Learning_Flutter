import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/main.dart';
import 'package:wanandroid_learning_flutter/model/login_entity.dart';
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
  final String _registerSuccessful = "successful";

  @override
  void initState() {
    _usernameController.addListener(() {
      if (_usernameController.text.trim().isNotEmpty) {
        setState(() {
          _isInputUsernameContent = true;
        });
      } else {
        setState(() {
          _isInputUsernameContent = false;
        });
      }
    });

    _passwordController.addListener(() {
      if (_passwordController.text.trim().isNotEmpty) {
        setState(() {
          _isInputPasswordContent = true;
        });
      } else {
        setState(() {
          _isInputPasswordContent = false;
        });
      }
    });

    _rePasswordController.addListener(() {
      if (_rePasswordController.text.trim().isNotEmpty) {
        setState(() {
          _isInputRePasswordContent = true;
        });
      } else {
        setState(() {
          _isInputRePasswordContent = false;
        });
      }
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

  Future<String> _register() async {
    print("username: ${_usernameController.text} "
        "password: ${_passwordController.text} "
        "rePassword: ${_rePasswordController.text}");
    try {
      FormData formData = new FormData.fromMap({
        "username": _usernameController.text,
        "password": _passwordController.text,
        "repassword": _rePasswordController.text,
      });
      Dio dio = new Dio();
      dio.options.baseUrl = "https://www.wanandroid.com";
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 3000;
      Response response = await dio
          .post("https://www.wanandroid.com/user/register", data: formData);
      LoginEntity loginEntity = JsonConvert.fromJsonAsT(response.data);
      if (loginEntity.errorCode == 0) {
        SpUtil().putString(Constant.usernameTag, _usernameController.text);
        Fluttertoast.showToast(msg: "注册成功：${loginEntity.data.username}");
        return _registerSuccessful;
      } else {
        Fluttertoast.showToast(msg: "注册失败：${loginEntity.errorMsg}");
        return loginEntity.errorMsg;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        image: new DecorationImage(
            image: AssetImage("assets/images/landscape.jpg"),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
            fit: BoxFit.fill),
      ),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            title: Text("Register Page"),
            backgroundColor: Colors.transparent,
          ),
          body: new Padding(
            padding: EdgeInsets.only(top: 50, left: 25, right: 25),
            child: new Column(
              children: <Widget>[
                new TextField(
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
                new TextField(
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
                new TextField(
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
                new Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new RaisedButton(
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
                            _register().then((value) => {
                                  if (value == _registerSuccessful)
                                    {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()),
                                          (route) => false)
                                    }
                                });
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
