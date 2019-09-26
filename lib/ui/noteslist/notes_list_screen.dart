import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/noteslist/notes_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class NotesListScreen extends BaseScreen {
  NotesListScreen(AppListener appListener) : super(appListener, title: "");

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
              "Notes",
              style: textTheme.display1.copyWith(
                color: Color.fromRGBO(22,102,237, 1.0),
                fontSize: 28
              ),
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
                      return buildNoteListItem(
                          not, Colors.white, onTap: () {
                        widget.appListener.router.navigateTo(
                            context, Screens.ADDNOTE.toString() + "/${not.id}/");
                      });
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Color.fromRGBO(22,102,237, 1.0),
        children: [
          SpeedDialChild(
            label: " Write your song Note",
            child: Icon(Icons.add),
            backgroundColor: Color.fromRGBO(22,102,237, 1.0),
            onTap: () async {
              await widget.appListener.router.navigateTo(context, Screens.ADDNOTE.toString() + "//");
            },
          ),
          SpeedDialChild(
            label: "Write your song idea",
            child: Icon(Icons.add),
            backgroundColor: Color.fromRGBO(22,102,237, 1.0),
            onTap: () async {
            
            },
          ),
        ],
      ),
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