import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  String _link;

  WebViewPage(String link) {
    this._link = link;
    print(link);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: _link,
        ),
      ),
    );
  }
}
