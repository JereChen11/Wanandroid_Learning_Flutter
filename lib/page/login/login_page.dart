import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_learning_flutter/api/api_service.dart';
import 'package:wanandroid_learning_flutter/model/user_bean.dart';
import 'package:wanandroid_learning_flutter/page/login/register_page.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isInputUsernameContent = false;
  bool _isInputPasswordContent = false;

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
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    var data = {
      "username": _usernameController.text,
      "password": _passwordController.text,
    };
    ApiService().login(data, (UserBean userBean) {
      if (userBean.errorCode == 0) {
        SpUtil().putString(Constant.usernameTag, _usernameController.text);
        SpUtil().putBool(Constant.isLoginKey, true);
        Fluttertoast.showToast(msg: "登入成功：${userBean.data.username}");
        Navigator.pop(context, "loginSuccessful");
      } else {
        Fluttertoast.showToast(msg: "登入失败：${userBean.errorMsg}");
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
          backgroundColor: Colors.transparent,
          title: Text("登入账号"),
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
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  child: Text("登入"),
                  color: Colors.white54,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () {
                    if (_isInputUsernameContent && _isInputPasswordContent) {
                      _login();
                      FocusScope.of(context).unfocus();
                    } else if (!_isInputUsernameContent) {
                      Fluttertoast.showToast(msg: "请输入用户名");
                    } else if (!_isInputPasswordContent) {
                      Fluttertoast.showToast(msg: "请输入密码");
                    } else {
                      Fluttertoast.showToast(msg: "请检查用户名与密码是否正确");
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 25),
                  child: GestureDetector(
                    child: Text(
                      "还没有注册? 点击注册",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
