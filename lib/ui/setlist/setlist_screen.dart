import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/setlist.dart';
import 'package:gigtrack/ui/setlist/setlist_presenter.dart';

import '../../utils/common_app_utils.dart';

class SetListScreen extends BaseScreen {
  final String bandId;
  SetListScreen(AppListener appListener, {this.bandId})
      : super(appListener, title: "");

  @override
  _SetListScreenState createState() => _SetListScreenState();
}

class _SetListScreenState
    extends BaseScreenState<SetListScreen, SetListPresenter>
    implements SetListContract {
  List<SetList> _setLists = [];

  Stream<List<SetList>> list;

  String bandName;

  @override
  AppBar get appBar => AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        title: Text(
          "${bandName ?? ""}",
          style: textTheme.title.copyWith(
            color: Colors.blueAccent,
          ),
        ),
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

                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        SetList setList = _setLists[index];
                        return FlatButton(
                          child: Text(
                            setList.setListName,
                            style: textTheme.button.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            widget.appListener.router.navigateTo(
                                context,
                                Screens.ADDSETLIST.toString() +
                                    "/${widget.bandId}/${setList.id}");
                          },
                        );
                      },
                      itemCount: _setLists.length,
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
        onPressed: () {
          widget.appListener.router.navigateTo(
              context, Screens.ADDSETLIST.toString() + "/${widget.bandId}/");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    list = presenter.getData(widget.bandId);
    presenter.getBand(widget.bandId);
  }

  @override
  void onBandDetails(Band res) {
    setState(() {
      bandName = res.name;
    });
  }

  @override
  SetListPresenter get presenter => SetListPresenter(this);
}
