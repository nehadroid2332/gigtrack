import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowWebUrl extends BaseScreen {
  String url;
  ShowWebUrl(AppListener appListener, {this.url})
      : super(appListener, title: "");

  @override
  _ShowWebUrlState createState() => _ShowWebUrlState();
}

class _ShowWebUrlState extends State<ShowWebUrl> {


  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    appBar: AppBar(
    title: const Text('Flutter WebView example'),
  ),
  body: const WebView(
  initialUrl: 'https://flutter.io',
  javascriptMode: JavascriptMode.unrestricted,
  ),
  );
  }
  }


