import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowWebUrlScreen extends BaseScreen {
  final String url;
  ShowWebUrlScreen(AppListener appListener, {this.url})
      : super(appListener, title: "");

  @override
  _ShowWebUrlState createState() => _ShowWebUrlState();
}

class _ShowWebUrlState extends State<ShowWebUrlScreen> {
  @override
  void initState() {
    super.initState();
    print("Url ${widget.url}");
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
