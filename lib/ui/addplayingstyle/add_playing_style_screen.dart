import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';

import 'add_playing_style_presenter.dart';

class AddPlayingStyleScreen extends BaseScreen {
  AddPlayingStyleScreen(AppListener appListener)
      : super(appListener, title: "Add Playing Style");

  @override
  _AddPlayingStyleScreenState createState() => _AddPlayingStyleScreenState();
}

class _AddPlayingStyleScreenState
    extends BaseScreenState<AddPlayingStyleScreen, AddPlayingStylePresenter> {
  final playingStylesList = <String>[
    "Asd23",
    "asd",
    "Afssd",
    "Asdsd",
    "asdsdafdf",
    "Dfrg",
    "Asdsd",
    "asdsdafdf",
    "Dfrg"
  ];
  final instrumentList = <String>[
    "sasadm",
    "dfdf",
    "dferfd",
    "dfsrer",
    "dferfd",
    "dfsrer",
    "fsfe",
    "egvffdfs"
  ];

  @override
  Widget buildBody() {
    List<Widget> items = [];
    for (String s in playingStylesList) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onTap: () {},
      ));
    }
    List<Widget> items2 = [];
    for (String s in instrumentList) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onTap: () {},
      ));
    }
    return ListView(
      padding: EdgeInsets.all(15),
      children: <Widget>[
        Text(
          "Playing Styles",
          style: textTheme.title.copyWith(
            color: Colors.white,
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        Wrap(
          children: items,
        ),
        Padding(padding: EdgeInsets.all(30)),
        Text(
          "Instruments",
          style: textTheme.title.copyWith(
            color: Colors.white,
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        Wrap(
          children: items2,
        ),
        Padding(padding: EdgeInsets.all(50)),
        RaisedButton(
          onPressed: () {},
          child: Text(
            "Submit",
          ),
        )
      ],
    );
  }

  @override
  AddPlayingStylePresenter get presenter => AddPlayingStylePresenter(this);
}
