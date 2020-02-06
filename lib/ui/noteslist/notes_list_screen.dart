import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/noteslist/notes_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import '../../server/models/notestodo.dart';
import '../../utils/common_app_utils.dart';

class NotesListScreen extends BaseScreen {
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;
  NotesListScreen(
    AppListener appListener, {
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "");

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState
    extends BaseScreenState<NotesListScreen, NotesListPresenter>
    implements NotesListContract {
  List<NotesTodo> _notes = <NotesTodo>[];

  Stream<List<NotesTodo>> list;

  bool allowArchieved = false;

  @override
  void initState() {
    super.initState();
    list = presenter.getList(widget.isLeader);
  }

  @override
  AppBar get appBar => AppBar(
    brightness: Brightness.light,
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
    // FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(99, 97, 93, .8));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blue, // Color for Android
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor:
            Colors.blue // Dark == white status bar -- for IOS.
        ));
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
                  'assets/images/notesicon.svg',
                  height: 40.0,
                  width: 40.0,
                  //allowDrawingOutsideViewBox: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Notes/Ideas",
                  style: textTheme.display1.copyWith(
                      color: Color.fromRGBO(3, 54, 255, 1.0),
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
              child: StreamBuilder<List<NotesTodo>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _notes = snapshot.data;

                    List<NotesTodo> notes = [];
                    List<NotesTodo> archieved = [];

                    for (var note in _notes) {
                      if ((widget.bandId == null || widget.bandId.isEmpty) ||
                          (widget.bandId != null &&
                              (note.status == NotesTodo.STATUS_APPROVED ||
                                  (widget.isLeader ||
                                      (note.user_id != null &&
                                          note.user_id ==
                                              presenter.serverAPI
                                                  .currentUserId))))) {
                        if (note.isArchive) {
                          archieved.add(note);
                        } else {
                          notes.add(note);
                        }
                      }
                    }

                    return ListView(
                      children: <Widget>[
                        FlatButton(
                          child: Text("",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18)),
                          onPressed: () {
                            setState(() {
                              allowArchieved = !allowArchieved;
                            });
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: notes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final not = notes[index];
                            return buildNoteListItem(not, Colors.white,
                                onTap: (widget.isLeader &&
                                            widget.bandId != null) ||
                                        widget.bandId.isEmpty ||
                                        (widget.bandId != null && widget.isComm)
                                    ? () {
                                        widget.appListener.router.navigateTo(
                                            context,
                                            Screens.ADDNOTE.toString() +
                                                "/${not.id}//${widget.bandId}/////${not.type ?? NotesTodo.TYPE_NOTE}/");
                                      }
                                    : null);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        FlatButton(
                          child: Text(
                            "Archived Notes/Ideas",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 18),
                          ),
                          onPressed: () {
                            setState(() {
                              allowArchieved = !allowArchieved;
                            });
                          },
                        ),
                        allowArchieved
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: archieved.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final not = archieved[index];
                                  return buildNoteListItem(not, Colors.white,
                                      onTap: (widget.isLeader &&
                                                  widget.bandId != null) ||
                                              widget.bandId.isEmpty ||
                                              (widget.bandId != null &&
                                                  widget.isComm)
                                          ? () {
                                              widget.appListener.router.navigateTo(
                                                  context,
                                                  Screens.ADDNOTE.toString() +
                                                      "/${not.id}//${widget.bandId}/////${not.type ?? NotesTodo.TYPE_NOTE}/");
                                            }
                                          : null);
                                },
                              )
                            : Container(
                                padding: EdgeInsets.all(5),
                              )
                      ],
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
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: (widget.bandId != null && widget.isLeader) ||
              widget.bandId.isEmpty ||
              (widget.bandId != null && widget.isComm)
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.orange,
              children: [
                SpeedDialChild(
                  label: "Ideas",
                  child: Icon(Icons.add),
                  labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
                  backgroundColor: Color.fromRGBO(55, 0, 179, 1.0),
                  onTap: () async {
                    await widget.appListener.router.navigateTo(
                        context,
                        Screens.ADDNOTE.toString() +
                            "///${widget.bandId}/////${NotesTodo.TYPE_IDEA}/");
                  },
                ),
                SpeedDialChild(
                  label: " Note",
                  child: Icon(Icons.add),
                  labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
                  backgroundColor: Color.fromRGBO(55, 0, 179, 1.0),
                  onTap: () async {
                    await widget.appListener.router.navigateTo(
                        context,
                        Screens.ADDNOTE.toString() +
                            "///${widget.bandId}/////${NotesTodo.TYPE_NOTE}/");
                  },
                ),
                SpeedDialChild(
                  label: "Write your song",
                  labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromRGBO(55, 0, 179, 1.0),
                  onTap: () async {
                    showDialogConfirm();
                  },
                ),
              ],
            )
          : Container(),
    );
  }

  showDialogConfirm() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: new Text(
            "Coming soon!",
            textAlign: TextAlign.center,
          ),
          content: Text("Release date would be coming soon..."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text(
                "Okay",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(3, 218, 157, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  NotesListPresenter get presenter => NotesListPresenter(this);
}

//FloatingActionButton(
//onPressed: () async {
//await widget.appListener.router
//    .navigateTo(context, Screens.ADDNOTE.toString() + "//");
//},
//backgroundColor: Color.fromRGBO(22,102,237, 1.0),
//child: Icon(Icons.add,
//color: Colors.white,),
//),
