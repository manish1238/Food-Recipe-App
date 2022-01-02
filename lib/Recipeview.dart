import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  String url;

  RecipeView(this.url);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool isloading = true;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  late String finalUrl;

  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalUrl = widget.url.toString().replaceAll("http://", "https://");
    } else {
      finalUrl = widget.url;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Food recipe app"),
        ),
        body: Container(
          child: Center(
            child: WebView(
              initialUrl: finalUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webviewcontroller) {
                setState(() {
                  controller.complete(webviewcontroller);
                });
              },
            ),
          ),
        ));
  }
}
