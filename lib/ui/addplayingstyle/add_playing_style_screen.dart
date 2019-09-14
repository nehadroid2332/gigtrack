import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
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
  final personalHighlights = <String>[
    "Playing since age 5",
    "Playing since age 10",
    "Playing since age 15",
    "Playing 1-5 years",
    "Playing 6-10 years",
    "Playing 11-20 years",
    "Playing over 20 years",
    "Music Instructor",
    "College Grad",
    "College Grad-Music Degree"
  ];
  final instrumentList = <String>[
    "Guitar-Lead",
    "Guitar-Rhythm",
    "Bass",
    "Drums",
    "Keys",
    "Piano",
    "Harmonica",
    "Vocals-Lead",
    "Vocals-Harmony"
  ];
  final playingStylesList = <String>[
    "Bluegrass",
    "Blues",
    "Celtic",
    "Classic Rock",
    "Country",
    "Country Rock",
    "Easy Listening",
    "Gospel",
    "Jazz",
    "Metal",
    "Punjabi",
    "Punk",
    "Raggae"
  ];
  String _playingType="Playing since age 5";
  final Map<String, String> inList = Map();
  final Set<String> psList = Set();
  String selectedPHighlights;
  final _degreeController = TextEditingController();
  final _roleController = TextEditingController();
  void _handleRelationshipValueChange(String value) {
    setState(() {
     _playingType=value;
     selectedPHighlights=value;
    });
  }
  @override
  Widget buildBody() {
    List<Widget> items = [];
    for (String s in playingStylesList) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: psList.contains(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: psList.contains(s)
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
            if (psList.contains(s)) {
              psList.remove(s);
            } else
              psList.add(s);
          });
        },
      ));
    }
    List<Widget> items2 = [];
    for (String s in instrumentList) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: inList.containsKey(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: inList.containsKey(s)
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
            if (inList.containsKey(s)) {
              inList.remove(s);
            } else
              inList[s] = null;
          });
        },
      ));
    }
    List<Widget> prsnlHighlts = [];
    for (String s in personalHighlights) {
      prsnlHighlts.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: selectedPHighlights == s
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selectedPHighlights == s
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
            if (selectedPHighlights == s) {
              selectedPHighlights = null;
            } else
              selectedPHighlights = s;
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
                height: 60,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 5),
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
                  "Personal Highlights",
                  style: textTheme.headline.copyWith(
                    color: Color.fromRGBO(99, 108, 119, 1.0),
                  ),
                  textAlign: TextAlign.left,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "How long you have been playing?",
                  textAlign: TextAlign.left,
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(99, 108, 119, 1.0)
                  ),
                ),
                Padding(padding: EdgeInsets.all(5),),
                DropdownButton<String>(
                  items: personalHighlights.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                        style: TextStyle(
                            color: Color.fromRGBO(99, 108, 119, 1.0)
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: _handleRelationshipValueChange,
                  value: _playingType,
                )
                ,
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Roles",
                  textAlign: TextAlign.left,
                  style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(99, 108, 119, 1.0)
                  ),
                ),
                TextField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    labelText: "Enter Role",
                    labelStyle: TextStyle(
                      color: widget.appListener.primaryColorDark,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Degree",
                  textAlign: TextAlign.left,
                  style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(99, 108, 119, 1.0)
                  ),
                ),
                TextField(
                  controller: _degreeController,
                  decoration: InputDecoration(
                    labelText: "Enter Degree",
                    labelStyle: TextStyle(
                      color: widget.appListener.primaryColorDark,
                    ),
                  ),
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
                Padding(padding: EdgeInsets.all(10)),
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
                Padding(padding: EdgeInsets.all(5),),
                inList.length>0? Text(
                  "Select your expertise level :",
                  textAlign: TextAlign.left,
                  style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(99, 108, 119, 1.0)
                  ),
                ):Container(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: inList.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = inList.keys.elementAt(index);
                    String val = inList[key];
                    return Row(
                      children: <Widget>[
                        Text(key),
                        Expanded(
                          child: Container(),
                        ),
                        DropdownButton<String>(
                          items: <String>[
                            'Beginner',
                            'Intermediate',
                            "Professional"
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          value: val,
                          onChanged: (v) {
                            setState(() {
                              inList[key] = v;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                Padding(padding: EdgeInsets.all(20)),
                RaisedButton(
                  onPressed: () {
                    showLoading();
                    presenter.addPlayingStyle(UserPlayingStyle(
                      instruments: inList,
                      role: _roleController.text,
                      degree: _degreeController.text,
                      personalHighlights: selectedPHighlights,
                      playing_styles: List.from(psList),
                    ));
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
  void onUpdateSuccess() {
    showMessage("Updated Successfully");
  }
}
