import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'playing_style_list_presenter.dart';

class PlayingStyleListScreen extends BaseScreen {
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  PlayingStyleListScreen(
    AppListener appListener, {
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener);

  @override
  _PlayingStyleListScreenState createState() => _PlayingStyleListScreenState();
}

class _PlayingStyleListScreenState
    extends BaseScreenState<PlayingStyleListScreen, PlayingStyleListPresenter>
    implements PlayingStyleListContract {
  var playingStyleList = <UserPlayingStyle>[];

  Stream<List<UserPlayingStyle>> list;

  int count = 0;

  @override
  void initState() {
    super.initState();
    list = presenter.getList(widget.bandId);
  }

  @override
  AppBar get appBar => AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.appListener.primaryColorDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/contact_color.png',
                  height: 40,
                  width: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "EPK List",
                  style: textTheme.display1.copyWith(
                      color: Color.fromRGBO(60, 111, 54, 1.0),
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: StreamBuilder<List<UserPlayingStyle>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    playingStyleList = snapshot.data;
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) {
                      UserPlayingStyle userPlayingStyle =
                          playingStyleList[index];
                      return InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.all(10),
                          color: Color.fromRGBO(124, 180, 97, 1.0),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${userPlayingStyle.playing_styles[0]}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
//                                Text(
//                                  "${userPlayingStyle.instruments}",
//                                  style: TextStyle(color: Colors.white),
//                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: (widget.isLeader && widget.bandId.isNotEmpty) ||
                                widget.bandId.isEmpty
                            ? () async {
                                await widget.appListener.router.navigateTo(
                                    context,
                                    Screens.ADDPLAYINGSTYLE.toString() +
                                        "/${userPlayingStyle.id}/${widget.bandId}////");
                              }
                            : null,
                      );
                    },
                    itemCount: playingStyleList.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ((widget.bandId != null && widget.isLeader) ||
                  widget.bandId.isEmpty) &&
              count < 1
          ? FloatingActionButton(
              onPressed: () async {
                await widget.appListener.router.navigateTo(
                    context,
                    Screens.ADDPLAYINGSTYLE.toString() +
                        "//${widget.bandId}////");
              },
              child: Icon(Icons.add),
              backgroundColor: Color.fromRGBO(124, 180, 97, 1.0),
            )
          : Container(),
    );
  }

  @override
  PlayingStyleListPresenter get presenter => PlayingStyleListPresenter(this);

  @override
  void onData(List<UserPlayingStyle> acc) {
    setState(() {
      count = acc.length;
    });
    if (count > 0) {
      if ((widget.isLeader && widget.bandId.isNotEmpty) ||
          widget.bandId.isEmpty) {
        UserPlayingStyle userPlayingStyle = acc[0];
        widget.appListener.router.navigateTo(
            context,
            Screens.ADDPLAYINGSTYLE.toString() +
                "/${userPlayingStyle.id}/${widget.bandId}////");
      }
    }
  }
}
