import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';

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
  final educationsOptions = <String>[
    "High School Grad",
    "BS Degree",
    "Masters Degree",
    "Doctorate Degree",
    "Trade School",
    "Other"
  ];
  final experience = <String>[
    "Play on my own",
    "Taking lessens",
    "I am an instructor",
    "Garage Band",
    "Music School band",
    "Local Band",
    "Local Touring Band",
    "National Touring",
    "International Touring",
  ];
  bool isyearage;
  final Map<String, String> inList = Map();
  final Map<String, String> exList = Map();
  final Set<String> psList = Set();
  final _degreeController = TextEditingController();
  final _roleController = TextEditingController();
  final _ageController = TextEditingController();
  final _yearController = TextEditingController();
  final _listSchoolController = TextEditingController();
  final _earnController = TextEditingController();
  final _responseController = TextEditingController();
  final _expController = TextEditingController();
  String selectedEducation;

  bool isEducation = false;

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
                ? Color.fromRGBO(124, 180, 97, 1.0)
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
                ? Color.fromRGBO(124, 180, 97, 1.0)
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
    List<Widget> exps = [];
    for (String s in experience) {
      exps.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: exList.containsKey(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: exList.containsKey(s)
                ? Color.fromRGBO(124, 180, 97, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (exList.containsKey(s)) {
              exList.remove(s);
            } else
              exList[s] = null;
          });
        },
      ));
    }
    List<Widget> edcs = [];
    for (String s in educationsOptions) {
      edcs.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: selectedEducation == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selectedEducation == (s)
                ? Color.fromRGBO(124, 180, 97, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            selectedEducation = s;
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
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
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
                  "My Music Journey started",
                  textAlign: TextAlign.left,
                  style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(124, 180, 97, 1.0)),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Text("Select one"),
                Row(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          isyearage = value;
                        });
                      },
                      value: isyearage ?? false,
                    ),
                    Expanded(
                      child: TextField(
                        enabled: isyearage ?? false,
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: "Enter Age",
                          labelStyle: TextStyle(
                            color: widget.appListener.primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Expanded(
                      child: TextField(
                        enabled: isyearage ?? false,
                        controller: _yearController,
                        decoration: InputDecoration(
                          labelText: "Enter Year",
                          labelStyle: TextStyle(
                            color: widget.appListener.primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          isyearage = !value;
                        });
                      },
                      value: !(isyearage ?? true),
                    ),
                    Expanded(
                      child: TextField(
                        enabled: !(isyearage ?? true),
                        controller: _responseController,
                        decoration: InputDecoration(
                          labelText: "Type in your response",
                          labelStyle: TextStyle(
                            color: widget.appListener.primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(8)),
                ShowUp(
                  child: !isEducation
                      ? new GestureDetector(
                          onTap: () {
                            setState(() {
                              isEducation = true;
                            });
                          },
                          child: Text(
                            "Click here to add education",
                            style: textTheme.display1.copyWith(
                                color: widget.appListener.primaryColorDark,
                                fontSize: 14),
                          ),
                        )
                      : Container(),
                  delay: 1000,
                ),
                isEducation
                    ? Text(
                        "Education",
                        textAlign: TextAlign.left,
                        style: textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(124, 180, 97, 1.0)),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(3),
                ),
                isEducation
                    ? Wrap(
                        children: edcs,
                      )
                    : Container(),
                selectedEducation == "Other"
                    ? Column(
                        children: <Widget>[
                          TextField(
                            controller: _listSchoolController,
                            decoration: InputDecoration(
                              labelText: "List School",
                              labelStyle: TextStyle(
                                color: widget.appListener.primaryColorDark,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _earnController,
                            decoration: InputDecoration(
                              labelText:
                                  "What did you earn your academic degree in",
                              labelStyle: TextStyle(
                                color: widget.appListener.primaryColorDark,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Expeirence",
                  textAlign: TextAlign.left,
                  style: textTheme.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(124, 180, 97, 1.0)),
                ),
                Padding(padding: EdgeInsets.all(3)),
                Wrap(
                  children: exps,
                ),
                TextField(
                  controller: _expController,
                  decoration: InputDecoration(
                    labelText: "What else do you want viewer to know?",
                    labelStyle: TextStyle(
                      color: widget.appListener.primaryColorDark,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Select your Playing Styles",
                  style: textTheme.headline.copyWith(
                    color: Color.fromRGBO(124, 180, 97, 1.0),
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
                    color: Color.fromRGBO(124, 180, 97, 1.0),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Wrap(
                  children: items2,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                inList.length > 0
                    ? Text(
                        "Select your expertise level :",
                        textAlign: TextAlign.left,
                        style: textTheme.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(124, 180, 97, 1.0)),
                      )
                    : Container(),
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
                      playing_styles: List.from(psList),
                      earn: _earnController.text,
                      education: selectedEducation,
                      experience: List.from(exList.keys),
                      listSchool: _listSchoolController.text,
                      viewerKnow: _expController.text,
                    ));
                  },
                  child: Text(
                    "Submit",
                  ),
                  color: Color.fromRGBO(124, 180, 97, 1.0),
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
