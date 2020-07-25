import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  _defaultTextStyle() {
    return new TextStyle(fontSize: 20, color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: ListItemWidget(),);
//    return new Scaffold(
//        body: new Column(
//      children: <Widget>[
//        new Center(
//          child: new Image(
//            image: AssetImage("assets/images/computer_desktop.jpg"),
//            fit: BoxFit.fill,
//            width: 200,
//            height: 150,
//          ),
//        ),
//        new Padding(
//          padding: EdgeInsets.only(top: 20),
//          child: new Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              new Text("1111"),
//              new Text(
//                "2222",
//                style: TextStyle(fontSize: 20, color: Colors.red),
//              ),
//              new Text("3333")
//            ],
//          ),
//        ),
//        new Padding(
//          padding: EdgeInsets.only(top: 30),
//          child: new Text(
//            "HI",
//            style: TextStyle(fontSize: 20, color: Colors.blue),
//          ),
//        )
//      ],
//    ));
  }
}

class ListItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10), child: new Text(
          "JereChen test article list item this is article item title",
          style: TextStyle(fontSize: 12, color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),),

        new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              "author",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            new Text(
              "2020-7-24",
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            new Icon(Icons.favorite_border),
          ],
        ),
      ],
    );
  }
}
