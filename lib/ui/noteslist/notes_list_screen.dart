import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/noteslist/notes_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

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
              "Notes",
              style: textTheme.display1.copyWith(
                  color: Color.fromRGBO(22, 102, 237, 1.0), fontSize: 28),
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
                  }
                  return ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final not = _notes[index];
                      return buildNoteListItem(not, Colors.white,
                          onTap: (widget.isLeader && widget.bandId != null) ||
                                  widget.bandId.isEmpty ||
                                  (widget.bandId != null && widget.isComm)
                              ? () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDNOTE.toString() +
                                          "/${not.id}//${widget.bandId}////");
                                }
                              : null);
                    },
                  );
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
              backgroundColor: Color.fromRGBO(22, 102, 237, 1.0),
              children: [
                SpeedDialChild(
                  label: "Ideas",
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromRGBO(22, 102, 237, 1.0),
                  onTap: () async {
                    showDialogConfirm();
                  },
                ),
                SpeedDialChild(
                  label: " Note",
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromRGBO(22, 102, 237, 1.0),
                  onTap: () async {
                    await widget.appListener.router
                        .navigateTo(context, Screens.ADDNOTE.toString() + "///${widget.bandId}////");
                  },
                ),
                SpeedDialChild(
                  label: "Write your song",
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromRGBO(22, 102, 237, 1.0),
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
            "Information!",
            textAlign: TextAlign.center,
          ),
          content: Text("Release date would be coming soon..."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text("Okay",
              textAlign: TextAlign.center,),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(22, 102, 237, 1.0),
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
