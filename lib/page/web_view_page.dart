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
          javascriptChannels: <JavascriptChannel>[_jsChannel(context)].toSet(),
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  ///这里定义Js调用Flutter本地方法的桥
  JavascriptChannel _jsChannel(BuildContext context) {
    return JavascriptChannel(
        name: "finish",
        onMessageReceived: (JavascriptMessage message) {
          print("js call flutter finish function");
        });
  }
}
