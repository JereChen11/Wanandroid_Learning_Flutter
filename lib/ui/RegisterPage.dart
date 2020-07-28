import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: new Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/images/landscape.jpg"),
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  fit: BoxFit.fill),
            ),
          ),
          new Positioned(
              child: new Padding(
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
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: "密码",
                      hintText: "请输入密码",
                      prefixIcon: Icon(Icons.lock)),
                ),
                new TextField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: "确认密码",
                      hintText: "请再次确认密码",
                      prefixIcon: Icon(Icons.lock_outline)),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new RaisedButton(
                      child: Text("注册"),
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
                    child: new GestureDetector(
                      child: Text(
                        "还没有注册? 点击注册",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
