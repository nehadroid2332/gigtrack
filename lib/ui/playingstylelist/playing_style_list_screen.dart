import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
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
  var playingStyleList = <UserPlayingStyle>[];

  Stream<List<UserPlayingStyle>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getList();
  }

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<List<UserPlayingStyle>>(
        stream: list,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            playingStyleList = snapshot.data;
          }
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemBuilder: (BuildContext context, int index) {
              UserPlayingStyle userPlayingStyle = playingStyleList[index];
              return Card(
                color: Color.fromRGBO(124, 180, 97, 1.0),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${userPlayingStyle.playing_styles}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${userPlayingStyle.instruments}",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: playingStyleList.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDPLAYINGSTYLE.toString());
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(124, 180, 97, 1.0),
      ),
    );
  }

  @override
  PlayingStyleListPresenter get presenter => PlayingStyleListPresenter(this);
}
