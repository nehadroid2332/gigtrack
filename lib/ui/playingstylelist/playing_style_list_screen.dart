import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';

import 'playing_style_list_presenter.dart';

class PlayingStyleListScreen extends BaseScreen {
  PlayingStyleListScreen(AppListener appListener)
      : super(appListener, title: "Playing Style List");

  @override
  _PlayingStyleListScreenState createState() => _PlayingStyleListScreenState();
}

class _PlayingStyleListScreenState
    extends BaseScreenState<PlayingStyleListScreen, PlayingStyleListPresenter> {
  final playingStyleList = <String>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
//      showLoading();
//      presenter.getList();
    });
  }

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          String ac = playingStyleList[index];
          return Card(
            child: Column(
              children: <Widget>[
                Text(
                  "Playing Style",
                  style: textTheme.subhead,
                ),
                Text(
                  "Instruments",
                  style: textTheme.caption,
                )
              ],
            ),
          );
        },
        itemCount: playingStyleList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDPLAYINGSTYLE.toString());
//          showLoading();
//          presenter.getList();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  PlayingStyleListPresenter get presenter => PlayingStyleListPresenter(this);
}
