import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/ui/Test.dart';

class KnowledgeSystemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: RaisedButton(
        child: Text("KnowledgeSystemPage",
            style: TextStyle(fontSize: 15, color: Colors.deepPurpleAccent)),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TestPage()));
        },
      ),
    );
  }
}
