import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/ui/bulletinboardlist/bulletinboard_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class BulletInBoardListScreen extends BaseScreen {
  BulletInBoardListScreen(AppListener appListener)
      : super(appListener, title: "");

  @override
  _BulletInBoardListScreenState createState() =>
      _BulletInBoardListScreenState();
}

class _BulletInBoardListScreenState
    extends BaseScreenState<BulletInBoardListScreen, BulletInBoardListPresenter>
    implements BulletInBoardListContract {
  List<BulletInBoard> _notes = <BulletInBoard>[];

  Stream<List<BulletInBoard>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getList();
  }

  @override
  AppBar get appBar => AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(105, 114, 98, 1.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Bulletin Board",
              style: textTheme.display1.copyWith(
                  color: Color.fromRGBO(22, 102, 237, 1.0), fontSize: 28),
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: StreamBuilder<List<BulletInBoard>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _notes = snapshot.data;
                  }
                  return ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bulletin = _notes[index];
                      return buildBulletInBoardListItem(bulletin, Colors.white,
                          onTap: () {
                        widget.appListener.router.navigateTo(context,
                            Screens.ADDBULLETIN.toString() + "/${bulletin.id}");
                      });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDBULLETIN.toString() + "/");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  BulletInBoardListPresenter get presenter => BulletInBoardListPresenter(this);
}
