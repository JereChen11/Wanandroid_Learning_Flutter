import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserWebView extends StatelessWidget {
  String _link;

  BrowserWebView(String link) {
    this._link = link;
    print(link);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("ArticleDetailPage"),
      ),
      body: new WebView(
        initialUrl: _link,
      ),
    );
  }
}
