import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band_comm.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import 'band_comm_list_presenter.dart';

class BandCommListScreen extends BaseScreen {
  final String bandId;

  BandCommListScreen(AppListener appListener,
      {this.bandId, bool isLeader, bool isComm, bool isSetUp, bool postEntries})
      : super(appListener, title: "");

  @override
  _BandCommListScreenState createState() => _BandCommListScreenState();
}

class _BandCommListScreenState
    extends BaseScreenState<BandCommListScreen, BandCommListPresenter> {
  List<BandCommunication> _notes = <BandCommunication>[];

  Stream<List<BandCommunication>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getList(widget.bandId);
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
                  "Band Communication",
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
              child: StreamBuilder<List<BandCommunication>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _notes = snapshot.data;

                    return ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final bulletin = _notes[index];
                        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                            bulletin.responseDate ??
                                DateTime.now().millisecondsSinceEpoch);
                        return Card(
                          margin: EdgeInsets.all(10),
                          color: (bulletin.isArchieve ?? false)
                              ? Color.fromRGBO(214, 22, 35, 0.5)
                              : Color.fromRGBO(214, 22, 35, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${bulletin.priority}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(3),
                                    ),
                                    Text(
                                      "${"${bulletin.title}"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(3),
                                    ),
                                    Text(
                                      "${formatDate(dateTime, [
                                        DD,
                                        ', ',
                                        mm,
                                        '/',
                                        dd,
                                        '/',
                                        yy,
                                      ])}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                await widget.appListener.router.navigateTo(
                                    context,
                                    Screens.ADD_BAND_COMM.toString() +
                                        "/${bulletin.id}//${widget.bandId}/////");
                              }),
                        );
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
          await widget.appListener.router.navigateTo(context,
              Screens.ADD_BAND_COMM.toString() + "///${widget.bandId}/////");
        },
        backgroundColor: Color.fromRGBO(214, 22, 35, 1.0),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  BandCommListPresenter get presenter => BandCommListPresenter(this);
}
