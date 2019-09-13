import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/noteslist/notes_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class PrivacyScreen extends BaseScreen {
  PrivacyScreen(AppListener appListener) : super(appListener, title: "");

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends BaseScreenState<PrivacyScreen, NotesListPresenter>
    implements NotesListContract {


  @override
  void initState() {
    super.initState();

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
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: ""
                    ),
                  )
              ),
            ),

          ],
        ),
      ),

    );
  }

  @override
  NotesListPresenter get presenter => NotesListPresenter(this);
}
