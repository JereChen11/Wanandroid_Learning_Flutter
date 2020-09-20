import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid_learning_flutter/generated/json/base/json_convert_content.dart';
import 'package:wanandroid_learning_flutter/model/knowledge_system_entity.dart';
import 'package:wanandroid_learning_flutter/ui/knowledge_system_article_list_page.dart';
import 'package:wanandroid_learning_flutter/widget/MyCircularProgressIndicator.dart';

class KnowledgeSystemPage extends StatefulWidget {
  @override
  _KnowledgeSystemPageState createState() => _KnowledgeSystemPageState();
}

class _KnowledgeSystemPageState extends State<KnowledgeSystemPage> {
  Future<KnowledgeSystemEntity> _retrieveKnowledgeSystemData() async {
    try {
      Response response =
          await Dio().get("https://www.wanandroid.com/tree/json");
      print(response);
      KnowledgeSystemEntity knowledgeSystemEntity =
          JsonConvert.fromJsonAsT(response.data);
      return knowledgeSystemEntity;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: FutureBuilder(
          future: _retrieveKnowledgeSystemData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                KnowledgeSystemEntity knowledgeSystemEntity = snapshot.data;
                // 请求成功，显示数据
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      new ExpansionItem(knowledgeSystemEntity.data[index]),
                  itemCount: knowledgeSystemEntity.data.length,
                );
              }
            } else {
              // 请求未结束，显示loading
              return MyCircularProgressIndicator();
            }
          },
        ),
      ),
    ));
  }
}

class ExpansionItem extends StatelessWidget {
  KnowledgeSystemData _knowledgeSystemData;

  ExpansionItem(this._knowledgeSystemData);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.menu),
      title: Text(_knowledgeSystemData.name),
      children: <Widget>[
        ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15, left: 30),
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).cardTheme.color,
                elevation: 30,
                shadowColor: Colors.black.withOpacity(0.3),
                margin: const EdgeInsets.only(right: 25),
                child: InkWell(
                  splashColor: Theme.of(context).primaryColor,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                KnowledgeSystemArticleListPage(
                                    _knowledgeSystemData.children[index].name,
                                    _knowledgeSystemData.children[index].id)));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      _knowledgeSystemData.children[index].name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: _knowledgeSystemData.children.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: ScrollController(),
        )
      ],
    );
  }
}
