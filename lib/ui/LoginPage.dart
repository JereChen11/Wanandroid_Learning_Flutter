import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/login_entity.dart';
import 'package:wanandroid_learning_flutter/ui/RegisterPage.dart';
import 'package:wanandroid_learning_flutter/utils/Constant.dart';
import 'package:wanandroid_learning_flutter/utils/SpUtil.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    print(
        "username: ${_usernameController.text} password: ${_passwordController.text}");
    try {
      FormData formData = new FormData.fromMap({
        "username": _usernameController.text,
        "password": _passwordController.text,
      });
      Response response = await Dio()
          .post("https://www.wanandroid.com/user/login?", data: formData);
      LoginEntity loginEntity = JsonConvert.fromJsonAsT(response.data);
      if (loginEntity.errorCode == 0) {
        SpUtil().putString(Constant.usernameTag, _usernameController.text);
        Fluttertoast.showToast(msg: "登入成功：${loginEntity.data.username}");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "登入失败：${loginEntity.errorMsg}");
      }
      print(response.data.toString());
    } catch (e) {
      print("catch exception: ${e}");
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
          backgroundColor: Colors.transparent,
          title: new Text("Login Page"),
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
              new Padding(
                padding: EdgeInsets.only(top: 20),
                child: new RaisedButton(
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
              new Expanded(
                child: new Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 25),
                  child: new GestureDetector(
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
