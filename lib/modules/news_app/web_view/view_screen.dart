import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen(this.url,{Key? key }) : super(key: key);
 final String url;
  //WebViewScreen(this.url);

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
