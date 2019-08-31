
import 'package:flutter/material.dart';
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
  final _notes = <NotesTodo>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getNotes();
    });
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
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Notes Lists",
              style: textTheme.display1.copyWith(
                color: widget.appListener.primaryColorDark,
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (BuildContext context, int index) {
                  final not = _notes[index];
                  return buildNoteListItem(not, widget.appListener.primaryColor,
                      onTap: () {
                    widget.appListener.router.navigateTo(
                        context, Screens.ADDNOTE.toString() + "/${not.id}");
                  });
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDNOTE.toString() + "/");
          showLoading();
          presenter.getNotes();
        },
        backgroundColor: Color.fromRGBO(255, 0, 104, 1.0),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  NotesListPresenter get presenter => NotesListPresenter(this);

  @override
  void getNotes(List<NotesTodo> data) {
    if (!mounted) return;
    hideLoading();
    setState(() {
      _notes.clear();
      _notes.addAll(data);
    });
  }
}
