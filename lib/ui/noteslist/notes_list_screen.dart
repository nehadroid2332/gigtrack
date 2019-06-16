import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/noteslist/notes_list_presenter.dart';

class NotesListScreen extends BaseScreen {
  NotesListScreen(AppListener appListener) : super(appListener, title: "Notes List");

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState
    extends BaseScreenState<NotesListScreen, NotesListPresenter> {
  @override
  Widget buildBody() {
    return Scaffold(
      body: ListView.builder(
        itemCount: 8,
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Start: 12/12/12 03:45 PM",
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "End: 11/12/12 03:45 PM",
                          style: TextStyle(fontSize: 11),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.appListener.router
              .navigateTo(context, Screens.ADDNOTE.toString());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  NotesListPresenter get presenter => NotesListPresenter(this);
}
