import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/playing_style_response.dart';

import 'playing_style_list_presenter.dart';

class PlayingStyleListScreen extends BaseScreen {
  PlayingStyleListScreen(AppListener appListener)
      : super(appListener, title: "Playing Style List");

  @override
  _PlayingStyleListScreenState createState() => _PlayingStyleListScreenState();
}

class _PlayingStyleListScreenState
    extends BaseScreenState<PlayingStyleListScreen, PlayingStyleListPresenter>
    implements PlayingStyleListContract {
  final playingStyleList = <UserPlayingStyle>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.playingStyleList();
    });
  }

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          UserPlayingStyle userPlayingStyle = playingStyleList[index];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${userPlayingStyle.playingStyle}",
                    style: textTheme.subhead,
                  ),
                  Text(
                    "${userPlayingStyle.instrument}",
                    style: textTheme.caption,
                  )
                ],
              ),
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

  @override
  void onListSuccess(List<UserPlayingStyle> list, List<Instruments> iList,
      List<PlayingStyle> pList) {
    for (UserPlayingStyle up in list) {
      up.setNames(pList, iList);
    }
    hideLoading();
    setState(() {
      playingStyleList.clear();
      playingStyleList.addAll(list);
    });
  }
}
