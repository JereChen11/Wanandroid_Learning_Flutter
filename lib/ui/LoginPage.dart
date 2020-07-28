import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/ui/RegisterPage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        image: new DecorationImage(
            image: AssetImage("assets/images/landscape.jpg"),
            colorFilter: new ColorFilter.mode(
                Colors.grey.withOpacity(0.7), BlendMode.dstATop),
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
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名或邮箱",
                    prefixIcon: Icon(Icons.account_circle)),
              ),
              new TextField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "请输入密码",
                    prefixIcon: Icon(Icons.lock)),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20),
                child: new RaisedButton(
                    child: Text("登入"),
                    color: Colors.white54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      print("onPressed login button");
                    }),
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
                          color: Colors.black54,
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
