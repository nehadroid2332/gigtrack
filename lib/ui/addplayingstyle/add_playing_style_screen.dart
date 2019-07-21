import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/playing_style_response.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import 'add_playing_style_presenter.dart';

class AddPlayingStyleScreen extends BaseScreen {
  AddPlayingStyleScreen(AppListener appListener)
      : super(appListener, title: "Add Playing Style");

  @override
  _AddPlayingStyleScreenState createState() => _AddPlayingStyleScreenState();
}

class _AddPlayingStyleScreenState
    extends BaseScreenState<AddPlayingStyleScreen, AddPlayingStylePresenter>
    implements AddPlayingStyleContract {
  final playingStylesList = <PlayingStyle>[];
  final instrumentList = <Instruments>[];

  final Set<String> psList = Set();
  final Set<String> inList = Set();

  @override
  void initState() {
    super.initState();
    showLoading();
    presenter.getList();
  }

  @override
  Widget buildBody() {
    List<Widget> items = [];
    for (PlayingStyle s in playingStylesList) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s.title,
            style: textTheme.subtitle.copyWith(),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: psList.contains(s.id) ? Colors.grey : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onTap: () {
          setState(() {
            psList.add(s.id);
          });
        },
      ));
    }
    List<Widget> items2 = [];
    for (Instruments s in instrumentList) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s.title,
            style: textTheme.subtitle.copyWith(),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: inList.contains(s.id) ? Colors.grey : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onTap: () {
          setState(() {
            inList.add(s.id);
          });
        },
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
          onPressed: () {
            showLoading();
            String userId = widget.appListener.sharedPreferences
                .getString(SharedPrefsKeys.USERID.toString());
            String psId = "";
            String inId = "";

            if (psList.length == 1) {
              psId = psList.first;
            } else {
              for (String p in psList) {
                psId += p + ",";
              }
            }
            if (inList.length == 1) {
              inId = inList.first;
            } else {
              for (String i in inList) {
                inId += i + ",";
              }
            }
            presenter.addPlayingStyle(userId, psId, inId);
          },
          child: Text(
            "Submit",
          ),
        )
      ],
    );
  }

  @override
  AddPlayingStylePresenter get presenter => AddPlayingStylePresenter(this);

  @override
  void onAddSuccess() {
    hideLoading();
    Navigator.pop(context);
  }

  @override
  void onListSuccess(List<UserPlayingStyle> list, List<Instruments> iList,
      List<PlayingStyle> pList) {
    hideLoading();
    setState(() {
      playingStylesList.clear();
      instrumentList.clear();
      playingStylesList.addAll(pList);
      instrumentList.addAll(iList);
    });
  }
}
