import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/noteslist/notes_list_presenter.dart';
import 'package:date_format/date_format.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class NotesListScreen extends BaseScreen {
  NotesListScreen(AppListener appListener)
      : super(appListener, title: "Notes List");

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
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: _notes.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          final not = _notes[index];
          return buildNoteListItem(not, onTap: () {
            widget.appListener.router
                .navigateTo(context, Screens.ADDNOTE.toString() + "/${not.id}");
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDNOTE.toString() + "/");
          showLoading();
          presenter.getNotes();
        },
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
