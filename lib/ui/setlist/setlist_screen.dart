import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/setlist.dart';
import 'package:gigtrack/ui/setlist/setlist_presenter.dart';

class SetListScreen extends BaseScreen {
  final String id;
  SetListScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _SetListScreenState createState() => _SetListScreenState();
}

class _SetListScreenState
    extends BaseScreenState<SetListScreen, SetListPresenter> {
  List<SetList> _setLists = [];

  Stream<List<SetList>> list;

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
              "Set-List",
              style: textTheme.display1.copyWith(
                  color: Color.fromRGBO(22, 102, 237, 1.0), fontSize: 28),
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: StreamBuilder(
                stream: list,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _setLists = snapshot.data;
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      SetList setList = _setLists[index];
                      List<Widget> widgets = [];
                      for (Song song in setList.songs) {
                        widgets.add(
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    song.name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text("-"),
                                Expanded(
                                  child: Text(
                                    song.artist,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text("*"),
                                Expanded(
                                  child: Text(
                                    song.perform,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ExpansionTile(
                        title: Container(
                          child: Text(setList.setListName),
                        ),
                        children: widgets,
                      );
                    },
                    itemCount: _setLists.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.appListener.router.navigateTo(
              context, Screens.ADDSETLIST.toString() + "/${widget.id}/");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    list = presenter.getData(widget.id);
  }

  @override
  SetListPresenter get presenter => SetListPresenter(this);
}
