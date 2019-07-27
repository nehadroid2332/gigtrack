import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/playing_style_response.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import 'add_playing_style_presenter.dart';

class AddPlayingStyleScreen extends BaseScreen {
  AddPlayingStyleScreen(AppListener appListener) : super(appListener);

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
            style: textTheme.subtitle.copyWith(
                color: psList.contains(s.id)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: psList.contains(s.id)
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (psList.contains(s.id)) {
              psList.remove(s.id);
            } else
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
            style: textTheme.subtitle.copyWith(
                color: inList.contains(s.id)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: inList.contains(s.id)
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (inList.contains(s.id)) {
              inList.remove(s.id);
            } else
              inList.add(s.id);
          });
        },
      ));
    }

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back,
                      color: widget.appListener.primaryColorDark,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset(
                'assets/images/music.png',
                height: 100,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                Text(
                  "Playing Styles",
                  style: textTheme.display1.copyWith(
                    color: widget.appListener.primaryColorDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Select your Playing Styles",
                  style: textTheme.headline.copyWith(
                    color: Color.fromRGBO(99, 108, 119, 1.0),
                  ),
                  textAlign: TextAlign.left,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Wrap(
                  children: items,
                ),
                Padding(padding: EdgeInsets.all(30)),
                Text(
                  "Instruments",
                  style: textTheme.title.copyWith(
                    color: Color.fromRGBO(99, 108, 119, 1.0),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Wrap(
                  children: items2,
                ),
                Padding(padding: EdgeInsets.all(20)),
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
                  color: Color.fromRGBO(255, 0, 104, 1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )
              ],
            ),
          )
        ],
      ),
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
