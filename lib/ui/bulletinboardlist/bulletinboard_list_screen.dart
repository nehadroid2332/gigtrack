import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(214, 22, 35, 1.0),
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
            Row(
              children: <Widget>[
                new SvgPicture.asset(
                  'assets/images/finalbulletin.svg',
                  height: 40.0,
                  width: 40.0,
                  //allowDrawingOutsideViewBox: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Bulletin Board",
                  style: textTheme.display1.copyWith(
                      color: Color.fromRGBO(214, 22, 35, 1.0),
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
              child: StreamBuilder<List<BulletInBoard>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _notes = snapshot.data;

                    return ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final bulletin = _notes[index];
                        return buildBulletInBoardListItem(
                            bulletin, Colors.white, onTap: () {
                          widget.appListener.router.navigateTo(
                              context,
                              Screens.ADDBULLETIN.toString() +
                                  "/${bulletin.id}");
                        });
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error Occured"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: AppProgressWidget(),
                    );
                  }
                  return Container();
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
        backgroundColor: Color.fromRGBO(214, 22, 35, 1.0),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  BulletInBoardListPresenter get presenter => BulletInBoardListPresenter(this);
}
