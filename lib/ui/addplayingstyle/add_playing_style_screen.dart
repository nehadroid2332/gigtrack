import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';
import 'package:image_picker/image_picker.dart';

import 'add_playing_style_presenter.dart';

class AddPlayingStyleScreen extends BaseScreen {
  final String id;
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  AddPlayingStyleScreen(
    AppListener appListener, {
    this.id,
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener);

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
  final education = [
    "Select",
    "High School Grad",
    "BS Degree",
    "Masters Degree",
    "Doctorate Degree",
    "Trade School",
    "Other"
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
    "Garage Band",
    "International Touring",
    "Local Band",
    "Local Bar Band",
    "Local Touring Band",
    "Music School band",
    "National Band",
    "Party Band - Casual",
    "Party Band - Formal",
    "Touring Band",
    "Wedding Band",
    "Other",
  ];
  int isyearage;
  bool isEdit = false;
  var _legalUserType;
  bool showYear;
  bool showage;
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
  final _otherExpController = TextEditingController();
  final _emailBandController = TextEditingController();
  final _websiteBandController = TextEditingController();
  final _nameBandController = TextEditingController();
  final _contactBandController = TextEditingController();
  final _aboutBandController = TextEditingController();
  String selectedEducation;
  var _educationType = "Select";
  var files = <String>[];

  bool isEducation = false;

  User user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id.isNotEmpty) {
        showLoading();
        presenter.getPlayingStyleDetails(widget.id);
      } else if (widget.bandId.isNotEmpty) {
        presenter.getbandDetails(widget.bandId);
      }
      presenter.getUserProfile();
    });
  }

  void _handleLegalUserValueChange(int value) {
    setState(() {
      isyearage = value;
      _legalUserType = value;
      if (_legalUserType == 1) {
        showYear = true;
        showage = false;
      } else if (_legalUserType == 0) {
        showage = true;
        showYear = false;
      }
    });
  }

  void _handleRelationshipValueChange(String value) {
    setState(() {
      _educationType = value;
      selectedEducation = value;
      if (_educationType == "Other") {
        _listSchoolController.text = "";
        _earnController.text = "";
      }
    });
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(60, 111, 54, 1.0),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                ),
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (widget.id == null || widget.id.isEmpty) {
                      showMessage("Id cannot be null");
                    } else {
                      _showDialogConfirm();
                      // presenter.instrumentDelete(id);
                      // Navigator.of(context).pop();
                    }
                  },
                )
        ],
      );

  void _showDialogConfirm() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: new Text(
            "Warning",
            textAlign: TextAlign.center,
          ),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text("Yes"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(60, 111, 55, 1.0),
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  showLoading();
                  presenter.deletePlayingStyle(widget.id);
                  //Navigator.of(context).pop();
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      Screens.PLAYINGSTYLELIST.toString() + "/////"));
                }
              },
            ),
          ],
        );
      },
    );
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
                ? Color.fromRGBO(124, 180, 97, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (psList.contains(s)) {
                    psList.remove(s);
                  } else
                    psList.add(s);
                });
              }
            : null,
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
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (inList.containsKey(s)) {
                    inList.remove(s);
                  } else
                    inList[s] = null;
                });
              }
            : null,
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
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (exList.containsKey(s)) {
                    exList.remove(s);
                  } else
                    exList[s] = null;
                });
              }
            : null,
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
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  selectedEducation = s;
                });
              }
            : null,
      ));
    }

    String expss = "";
    for (String s in exList.keys) {
      expss += s + ",";
    }
    if (expss.isNotEmpty) expss = expss.substring(0, expss.length - 1);
    String plyss = "";

    if (plyss.isNotEmpty) plyss = plyss.substring(0, plyss.length - 1);
    psList.join(",");

    for (String s in psList) {
      plyss += s + " , ";
    }
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(60, 111, 54, 1.0),
            height: height / 2.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.id.isEmpty ? "Add" : isEdit ? "Edit" : ""} EPK",
                style: textTheme.display1
                    .copyWith(color: Colors.white, fontSize: 28),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: ListView(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 5),
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(10)),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : files != null && files.length > 0
                              ? Container(
                                  margin: EdgeInsets.only(left: 30, right: 30),
                                  height:
                                      MediaQuery.of(context).size.height / 4.0,
                                  width: 90,
                                  child: Image.network(
                                    files[0],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Text(
                              "My Music Journey Started",
                              textAlign: widget.id.isEmpty || isEdit
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.title.copyWith(
                                  color: Color.fromRGBO(124, 180, 97, 1.0)),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Text("Select one")
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(6),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : widget.bandId.isNotEmpty
                              ? Text(
                                  "${_nameBandController.text}",
                                  textAlign: TextAlign.center,
                                  style: textTheme.headline,
                                )
                              : user != null
                                  ? Text(
                                      "${user?.firstName} ${user?.lastName}",
                                      textAlign: TextAlign.center,
                                      style: textTheme.headline,
                                    )
                                  : Container(),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: widget.id.isEmpty || isEdit
                                      ? () {
                                          _handleLegalUserValueChange(0);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _legalUserType == 0
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _legalUserType == 0
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    124, 180, 97, 1.0))),
                                    child: Text(
                                      'Age',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _legalUserType == 0
                                            ? Color.fromRGBO(124, 180, 97, 1.0)
                                            : Color.fromRGBO(124, 180, 97, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                ),
                                InkWell(
                                  onTap: widget.id.isEmpty || isEdit
                                      ? () {
                                          _handleLegalUserValueChange(1);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _legalUserType == 1
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _legalUserType == 1
                                                ? Color.fromRGBO(
                                                    124, 180, 97, 1.0)
                                                : Color.fromRGBO(
                                                    124, 180, 97, 1.0))),
                                    child: Text(
                                      'Year',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _legalUserType == 1
                                            ? Color.fromRGBO(124, 180, 97, 1.0)
                                            : Color.fromRGBO(124, 180, 97, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: widget.id.isEmpty || isEdit
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: <Widget>[
                          showage == true
                              ? (widget.id.isEmpty || isEdit
                                  ? Expanded(
                                      child: TextField(
                                        enabled: (widget.id.isEmpty || isEdit)
                                            ? isyearage == 0
                                            : false,
                                        controller: _ageController,
                                        decoration: InputDecoration(
                                          labelText: "Enter Age",
                                          labelStyle: TextStyle(
                                            color: widget
                                                .appListener.primaryColorDark,
                                          ),
                                        ),
                                      ),
                                    )
                                  : _ageController.text.isNotEmpty &&
                                          widget.bandId.isEmpty
                                      ? Text(
                                          "Playing since age  ${_ageController.text}",
                                          textAlign: TextAlign.center,
                                        )
                                      : Container())
                              : Container(),
                          showYear == true
                              ? (widget.id.isEmpty || isEdit
                                  ? Expanded(
                                      child: TextField(
                                        enabled: (widget.id.isEmpty || isEdit)
                                            ? isyearage == 1
                                            : false,
                                        controller: _yearController,
                                        decoration: InputDecoration(
                                          labelText: "Enter Year",
                                          labelStyle: TextStyle(
                                            color: widget
                                                .appListener.primaryColorDark,
                                          ),
                                        ),
                                      ),
                                    )
                                  : _yearController.text.isNotEmpty
                                      ? Text(
                                          "Playing since ${_yearController.text}",
                                          textAlign: TextAlign.center,
                                        )
                                      : Container())
                              : Container(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        mainAxisAlignment: widget.id.isEmpty || isEdit
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: <Widget>[
//                          widget.id.isEmpty || isEdit
//                              ? Checkbox(
//                                  onChanged: widget.id.isEmpty || isEdit
//                                      ? (bool value) {
//                                          setState(() {
//                                            isyearage = 2;
//                                          });
//                                        }
//                                      : null,
//                                  value: isyearage == 2,
//                                )
//                              : Container(),
                          widget.id.isEmpty || isEdit
                              ? Expanded(
                                  child: TextField(
                                    enabled: (widget.id.isEmpty || isEdit),
                                    controller: _responseController,
                                    decoration: InputDecoration(
                                      labelText:
                                          "Write something about you experience",
                                      labelStyle: TextStyle(
                                        color:
                                            widget.appListener.primaryColorDark,
                                      ),
                                    ),
                                    maxLines: 2,
                                  ),
                                )
                              : _responseController.text.isNotEmpty
                                  ? Text(
                                      "Response: ${_responseController.text}")
                                  : Container(),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        "Experience",
                        textAlign: widget.id.isEmpty || isEdit
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.title
                            .copyWith(color: Color.fromRGBO(124, 180, 97, 1.0)),
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      widget.id.isEmpty || isEdit
                          ? Wrap(
                              children: exps,
                            )
                          : Text(
                              expss,
                              textAlign: TextAlign.center,
                            ),
                      (widget.id.isEmpty || isEdit)
                          ? exList.containsKey("Other")
                              ? TextField(
                                  controller: _otherExpController,
                                )
                              : Container()
                          : expss.contains("Other")
                              ? RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "\nOther:\n",
                                          style: textTheme.subhead),
                                      TextSpan(
                                        text: _otherExpController.text,
                                        style: textTheme.caption,
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
//                      widget.id.isEmpty || isEdit
//                          ? TextField(
//                              enabled: widget.id.isEmpty || isEdit,
//                              controller: _expController,
//                              decoration: InputDecoration(
//                                labelText:
//                                    "What else do you want viewer to know?",
//                                labelStyle: TextStyle(
//                                  color: widget.appListener.primaryColorDark,
//                                ),
//                              ),
//                            )
//                          : Text(
//                              "Want from your viewer: ${_expController.text}",
//                              textAlign: TextAlign.center,
//                            ),
//                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                          widget.id.isEmpty || isEdit
                              ? "Select your Playing Styles"
                              : "Playing Style",
                          style: textTheme.title.copyWith(
                            color: Color.fromRGBO(124, 180, 97, 1.0),
                          ),
                          textAlign: widget.id.isEmpty || isEdit
                              ? TextAlign.left
                              : TextAlign.center),
                      Padding(padding: EdgeInsets.all(5)),
                      widget.id.isEmpty || isEdit
                          ? Wrap(
                              children: items,
                            )
                          : Text(
                              psList.join(" , "),
                              textAlign: TextAlign.center,
                            ),
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        "Instruments",
                        style: textTheme.title.copyWith(
                          color: Color.fromRGBO(124, 180, 97, 1.0),
                        ),
                        textAlign: widget.id.isEmpty || isEdit
                            ? TextAlign.left
                            : TextAlign.center,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      widget.id.isEmpty || isEdit
                          ? Wrap(
                              children: items2,
                            )
                          : Container(),

                      Padding(
                        padding: widget.id.isNotEmpty
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(5),
                      ),
                      inList.length > 0
                          ? widget.id.isEmpty || isEdit
                              ? Text(
                                  "Select your expertise level :",
                                  textAlign: TextAlign.left,
                                  style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(124, 180, 97, 1.0)),
                                )
                              : Container()
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: inList.keys.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = inList.keys.elementAt(index);
                          String val = inList[key];
                          return widget.id.isEmpty || isEdit
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(key),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    widget.id.isEmpty || isEdit
                                        ? DropdownButton<String>(
                                            items: <String>[
                                              'Beginner',
                                              'Intermediate',
                                              "Professional"
                                            ].map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(
                                                  value,
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }).toList(),
                                            value: val,
                                            onChanged: (v) {
                                              setState(() {
                                                inList[key] = v;
                                              });
                                            },
                                          )
                                        : Text("-" + val),
                                  ],
                                )
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "$key",
                                        textAlign: TextAlign.right,
                                        style: textTheme.subtitle.copyWith(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        " - ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "$val",
                                        textAlign: TextAlign.left,
                                      ),
                                      flex: 5,
                                    ),
//                                    Padding(
//                                      padding: EdgeInsets.all(4),
//                                    )
                                  ],
                                );
                        },
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      ShowUp(
                        child: !isEducation
                            ? new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEducation = true;
                                  });
                                },
                                child: widget.id.isEmpty || isEdit
                                    ? Text(
                                        "Click here to add education",
                                        style: textTheme.display1.copyWith(
                                            color: widget
                                                .appListener.primaryColorDark,
                                            fontSize: 14),
                                      )
                                    : Container(),
                              )
                            : Container(),
                        delay: 1000,
                      ),

                      isEducation
                          ? Text(
                              "Education",
                              textAlign: widget.id.isEmpty || isEdit
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.title.copyWith(
                                  color: Color.fromRGBO(124, 180, 97, 1.0)),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      isEducation
                          ? widget.id.isEmpty || isEdit
                              ? DropdownButton<String>(
                                  items: education.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: widget
                                                .appListener.primaryColorDark),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _handleRelationshipValueChange,
                                  value: _educationType,
                                )
                              : selectedEducation == "Other"
                                  ? Container()
                                  : Container()
                          : Container(),
//                      isEducation
//                          ? widget.id.isEmpty || isEdit
//                              ? Wrap(
//                                  children: edcs,
//                                )
//                              : Text(
//                                  selectedEducation,
//                                  textAlign: TextAlign.center,
//                                )
//                          : Container(),
                      Column(
                        children: <Widget>[
                          widget.id.isEmpty || isEdit
                              ? TextField(
                                  enabled: widget.id.isEmpty || isEdit,
                                  controller: _listSchoolController,
                                  decoration: InputDecoration(
                                    labelText: "List School",
                                    labelStyle: TextStyle(
                                      color:
                                          widget.appListener.primaryColorDark,
                                    ),
                                  ),
                                )
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "School",
                                        textAlign: TextAlign.right,
                                        style: textTheme.subtitle.copyWith(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        " - ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _listSchoolController.text,
                                        textAlign: TextAlign.left,
                                      ),
                                      flex: 5,
                                    )
                                  ],
                                ),
                          widget.id.isEmpty || isEdit
                              ? Container()
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "Degree",
                                        textAlign: TextAlign.right,
                                        style: textTheme.subtitle.copyWith(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        " - ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        selectedEducation ?? "",
                                        textAlign: TextAlign.left,
                                      ),
                                      flex: 5,
                                    )
                                  ],
                                )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : widget.bandId.isNotEmpty
                              ? Text(
                                  "Band Contact Info",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.bold),
                                )
                              : Container(),
                      widget.bandId.isNotEmpty
                          ? (widget.id.isEmpty || isEdit)
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    "${_nameBandController.text} - ${_contactBandController.text}",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Container(),
                      widget.bandId.isNotEmpty
                          ? (widget.id.isEmpty || isEdit)
                              ? TextField(
                                  controller: _emailBandController,
                                  decoration: InputDecoration(
                                    hintText: "Band Email",
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    _emailBandController.text,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Container(),
                      widget.bandId.isNotEmpty
                          ? (widget.id.isEmpty || isEdit)
                              ? TextField(
                                  controller: _websiteBandController,
                                  decoration: InputDecoration(
                                    hintText: "Band Website",
                                  ),
                                )
                              : Padding(
                                  child: Text(
                                    _websiteBandController.text,
                                    textAlign: TextAlign.center,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                )
                          : Container(),
                      (widget.id.isEmpty || isEdit)
                          ? Container()
                          : widget.bandId.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: Text(
                                    "About the Band",
                                    textAlign: TextAlign.center,
                                    style: textTheme.subhead
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                      widget.bandId.isNotEmpty
                          ? (widget.id.isEmpty || isEdit)
                              ? Container()
                              : Text(
                                  _aboutBandController.text,
                                  textAlign: TextAlign.center,
                                )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "${widget.id.isEmpty || isEdit ? 'Add Pictures' : ''}",
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          widget.id.isEmpty || isEdit
                              ? IconButton(
                                  icon: Icon(Icons.add_a_photo),
                                  onPressed: () {
                                    if (files.length < 2)
                                      getImage();
                                    else
                                      showMessage(
                                          "User can upload upto max 2 media files");
                                  },
                                )
                              : Container()
                        ],
                      ),
                      widget.id.isEmpty || isEdit
                          ? files.length > 0
                              ? SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                    itemCount: files.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      File file = File(files[index]);
                                      return file.path.startsWith("https")
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              height: 80,
                                              width: 150,
                                              child: Stack(
                                                children: <Widget>[
                                                  widget.id.isNotEmpty ||
                                                          isEdit &&
                                                              file.path
                                                                  .startsWith(
                                                                      "https")
                                                      ? Image.network(
                                                          file.path
                                                                  .toString() ??
                                                              "",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          file,
                                                          fit: BoxFit.cover,
                                                        ),
                                                  Positioned(
                                                    right: 14,
                                                    top: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          files = new List();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Icon(
                                                          Icons.cancel,
                                                          color: Colors.white,
                                                        ),
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              height: 80,
                                              width: 150,
                                              child: Stack(
                                                children: <Widget>[
                                                  Image.file(
                                                    file,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Positioned(
                                                    right: 14,
                                                    top: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          files = new List();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Icon(
                                                          Icons.cancel,
                                                          color: Colors.white,
                                                        ),
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                )
                              : Container()
                          : Container(),
                      Padding(padding: EdgeInsets.all(20)),
                      widget.id.isEmpty || isEdit
                          ? RaisedButton(
                              onPressed: () {
                                showLoading();
                                presenter.addPlayingStyle(UserPlayingStyle(
                                    instruments: inList,
                                    id: widget.id,
                                    role: _roleController.text,
                                    bandId: widget.bandId,
                                    degree: _degreeController.text,
                                    about: _aboutBandController.text,
                                    playing_styles: List.from(psList),
                                    earn: _earnController.text,
                                    otherExp: _otherExpController.text,
                                    education: selectedEducation,
                                    aboutBand: _nameBandController.text +
                                        "\n" +
                                        _emailBandController.text +
                                        "\n" +
                                        _websiteBandController.text,
                                    bandContacts: _contactBandController.text,
                                    bandEmail: _emailBandController.text,
                                    bandName: _nameBandController.text,
                                    bandWebsite: _websiteBandController.text,
                                    age: showage ? _ageController.text : null,
                                    year:
                                        showYear ? _yearController.text : null,
                                    experience: List.from(exList.keys),
                                    listSchool: _listSchoolController.text,
                                    viewerKnow: _expController.text,
                                    files: files));
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
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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

  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Image Picker"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Camera"),
              onPressed: () async {
                Navigator.of(context).pop();
                var image = await ImagePicker.pickImage(
                    source: ImageSource.camera, imageQuality: 50);

                setState(() {
                  if (image != null) files.add(image.path);
                });
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (image != null) files.add(image.path);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onUpdateSuccess() {
    hideLoading();
    setState(() {
      isEdit = false;
    });
    showMessage("Updated Successfully");
  }

  @override
  void onDetailsSuccess(UserPlayingStyle userPlayingStyle) {
    hideLoading();
    setState(() {
      files.clear();
      files.addAll(userPlayingStyle.files);
      _aboutBandController.text = userPlayingStyle.about;
      _otherExpController.text = userPlayingStyle.otherExp;
      _degreeController.text = userPlayingStyle.degree;
      _earnController.text = userPlayingStyle.earn;
      _expController.text = userPlayingStyle.viewerKnow;
      _listSchoolController.text = userPlayingStyle.listSchool;
      _responseController.text = userPlayingStyle.response;
      _roleController.text = userPlayingStyle.role;
      _yearController.text = userPlayingStyle.year;
      _ageController.text = userPlayingStyle.age;
      _aboutBandController.text = userPlayingStyle.aboutBand;
      _emailBandController.text = userPlayingStyle.bandEmail;
      _nameBandController.text = userPlayingStyle.bandName;
      _contactBandController.text = userPlayingStyle.bandContacts;
      _websiteBandController.text = userPlayingStyle.bandWebsite;
      isEducation = true;

      for (String item in userPlayingStyle.experience) {
        exList[item] = null;
      }
      selectedEducation = userPlayingStyle.education ?? "";
      if (userPlayingStyle.age != null) {
        isyearage = 0;
        showage = true;
      } else if (userPlayingStyle.year != null) {
        isyearage = 1;
        showYear = true;
      } else if (userPlayingStyle.response != null) {
        isyearage = 2;
      }
      psList.clear();
      psList.addAll(userPlayingStyle.playing_styles);
      inList.clear();
      inList.addAll(userPlayingStyle.instruments);
    });
  }

  @override
  void onDelete() {
    Navigator.of(context).pop();
  }

  @override
  void getBandDetails(Band res) {
    setState(() {
      _contactBandController.text = res.contactInfo;
      _nameBandController.text = res.name;
    });
  }

  @override
  void onUserDetailsSuccess(User res) {
    setState(() {
      user = res;
    });
  }
}
