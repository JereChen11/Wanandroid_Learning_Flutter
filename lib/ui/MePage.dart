import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/ui/LoginPage.dart';
import 'package:wanandroid_learning_flutter/utils/Constant.dart';
import 'package:wanandroid_learning_flutter/utils/SpUtil.dart';

class MePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Stack(
          alignment: AlignmentDirectional.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            new Container(
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Image(
                image: AssetImage("assets/images/landscape.jpg"),
                fit: BoxFit.fitWidth,
              ),
            ),
            new Positioned(
              top: 40,
              child: new GestureDetector(
                child: new Column(
                  children: <Widget>[
                    new Container(
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
                    new Text(
                      SpUtil().getString(Constant.usernameTag),
                      style: TextStyle(fontSize: 25, color: Colors.black38),
                    ),
                    new Text(
                      "jerechen11@gmail.com",
                      style: TextStyle(fontSize: 18, color: Colors.black38),
                    ),
                    new Container(
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
        new Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: 10,
          margin: EdgeInsets.only(top: 100),
        ),
        _MePageItem(Icons.face, "about us"),
        _MePageItem(Icons.print, "print"),
        _MePageItem(Icons.send, "Send"),
      ],
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
    return new Padding(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 5, left: 15),
            child: new Icon(
              _iconData,
              size: 30,
            ),
          ),
          new Expanded(
            child: new Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 20),
              child: Text(
                _type,
                style: TextStyle(fontSize: 20, color: Colors.black38),
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 5, right: 15),
            child: new Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
