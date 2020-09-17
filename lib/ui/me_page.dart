import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/ui/LoginPage.dart';
import 'package:wanandroid_learning_flutter/utils/constant.dart';
import 'package:wanandroid_learning_flutter/utils/sp_util.dart';

class MePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                color: Colors.blue,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4.5,
                child: Image(
                  image: AssetImage("assets/images/landscape.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 40,
                child: GestureDetector(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 10),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/landscape.jpg"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        SpUtil().getString(Constant.usernameTag),
                        style: TextStyle(fontSize: 25, color: Colors.black38),
                      ),
                      Text(
                        "jerechen11@gmail.com",
                        style: TextStyle(fontSize: 18, color: Colors.black38),
                      ),
                      Container(
                        width: 250,
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.only(top: 8),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
            ],
          ),
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 10,
            margin: EdgeInsets.only(top: 100),
          ),
          _MePageItem(Icons.face, "about us"),
          _MePageItem(Icons.print, "print"),
          GestureDetector(
            child: _MePageItem(Icons.send, "Send"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage())),
          )
//        _MePageItem(Icons.send, "Send"),
        ],
      ),
    );
  }
}

class _MePageItem extends StatelessWidget {
  IconData _iconData;
  String _type;

  _MePageItem(IconData iconData, String type) {
    this._iconData = iconData;
    this._type = type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, left: 15),
            child: new Icon(
              _iconData,
              size: 30,
            ),
          ),
          Expanded(
            child: new Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
              child: Text(
                _type,
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
