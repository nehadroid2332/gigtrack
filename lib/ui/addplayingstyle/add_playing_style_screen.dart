import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import '../../server/models/user_playing_style.dart';
import '../../server/models/user_playing_style.dart';
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
    "Select degree",
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
    "Raggae",
    "Other"
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
  final _musicPreviewController = TextEditingController();
  final _nameBandController = TextEditingController();
  final _contactBandController = TextEditingController();
  final _aboutBandController = TextEditingController();
  final _bandNameController = TextEditingController();
  final _descController = TextEditingController();
  final _yearFromController = TextEditingController();
  final _yearToController = TextEditingController();
  final _playingStyleController = TextEditingController();
  String selectedEducation;
  var _educationType = "Select degree";
  var files = <String>[];
  List<String> aboutBandList = [""];

  bool isEducation = true;
  bool isExperience = false;
  String _errorMusic;

  User user;

  List<BandDetails> bandDetails = [];

  String _bandCity, _bandState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id.isNotEmpty) {
        showLoading();
        presenter.getPlayingStyleDetails(widget.id);
      }
      if (widget.bandId.isNotEmpty) {
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
        _ageController.text = '';
        showage = false;
      } else if (_legalUserType == 0) {
        showage = true;
        showYear = false;
        _yearController.text = '';
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

  bool qDarkmodeEnable = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    checkThemeMode();
  }

  void checkThemeMode() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var qdarkMode = MediaQuery.of(context).platformBrightness;
      if (qdarkMode == Brightness.dark) {
        setState(() {
          qDarkmodeEnable = true;
        });
      } else {
        setState(() {
          qDarkmodeEnable = false;
        });
      }
    }
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(250, 177, 49, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (isEdit) {
              final check = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Do you want to save changes?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black87),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color.fromRGBO(250, 177, 49, 1.0),
                        onPressed: () {
                          _submitEPK();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
              if (check) {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: widget.id.isEmpty
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2,
            child: Text(
              "${widget.id.isEmpty ? "Add" : isEdit ? "Edit" : ""} EPK",
              textAlign: TextAlign.center,
              style: textTheme.headline.copyWith(
                color: Colors.white,
              ),
            ),
          ),
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
              child: new Text("Yes"),
              textColor: Colors.black,
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  showLoading();
                  presenter.deletePlayingStyle(widget.id);
                  Navigator.of(context).pop();
                }
              },
            ),
            new RaisedButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(250, 177, 49, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
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
                ? Color.fromRGBO(250, 177, 49, 1.0)
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
                ? Color.fromRGBO(250, 177, 49, 1.0)
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
                ? Color.fromRGBO(250, 177, 49, 1.0)
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
                ? Color.fromRGBO(255, 222, 3, 1.0)
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
      expss += s + ", ";
    }

    if (expss.isNotEmpty) expss = expss.substring(0, expss.length - 2);

    String plyss = "";
    if (plyss.isNotEmpty) plyss = plyss.substring(0, plyss.length - 1);
    psList.join(", ");

    for (String s in psList) {
      plyss += s + ", ";
    }
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 4.5),
          child: Container(
            color: Color.fromRGBO(250, 177, 49, 1.0),
            height: height / 4.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: ListView(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 0),
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(10)),
//                      widget.id.isEmpty || isEdit
//                          ? Container()
//                          : files != null && files.length > 0
//                              ? Container(
//                                  margin: EdgeInsets.only(left: 10, right: 10),
//                                  height:
//                                      MediaQuery.of(context).size.height / 3.2,
//                                  //width: 95,
//                                  child: Image.network(
//                                    files[0],
//                                    fit: BoxFit.fitWidth,
//                                    alignment: Alignment.center,
//                                    colorBlendMode: BlendMode.darken,
//                                  ),
//                                )
//                              : Container(),
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : files != null && files.length > 0
                              ? ExtendedImage.network(
                                  files[0],
                                  width: 0,
                                  height:
                                      MediaQuery.of(context).size.height / 3.2,
                                  fit: BoxFit.fitHeight,
                                  cache: true,
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  scale: 6,
                                  mode: ExtendedImageMode.gesture,
                                  //cancelToken: cancellationToken,
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      (widget.id.isEmpty || isEdit) && widget.bandId.isEmpty
                          ? Text(
                              "My Music Journey Started",
                              textAlign: widget.id.isEmpty || isEdit
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.title.copyWith(
                                  color: Color.fromRGBO(250, 177, 49, 1.0)),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(
                            (widget.id.isEmpty || isEdit) ? 5 : 0),
                      ),
                      (widget.id.isEmpty || isEdit) && widget.bandId.isEmpty
                          ? Text("Select one")
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(0),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : user != null
                              ? widget.bandId.isNotEmpty
                                  ? Text(
                                      "${_nameBandController.text}",
                                      textAlign: TextAlign.center,
                                      style: textTheme.headline,
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Text(
                                          "${user?.firstName} ${user?.lastName}",
                                          textAlign: TextAlign.center,
                                          style: textTheme.headline,
                                        ),
                                      ],
                                    )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(
                            (widget.id.isEmpty || isEdit) ? 0 : 0),
                        child: (widget.bandId.isNotEmpty) &&
                                widget.id.isNotEmpty &&
                                !isEdit
                            ? Text(
                                "$_bandCity,$_bandState",
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                      ),
                      widget.bandId.isNotEmpty
                          ? (widget.id.isEmpty || isEdit)
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "About the Band",
                                    textAlign: TextAlign.center,
                                    style: textTheme.title.copyWith(
                                        color:
                                            Color.fromRGBO(250, 177, 49, 1.0)),
                                  ),
                                )
                          : Container(),
//                      (widget.bandId.isNotEmpty) &&
//                              (widget.id.isEmpty || isEdit)
//                          ? Container()
//                          : Container(
//                              child: aboutBandList.isNotEmpty
//                                  ? Text(
//                                      aboutBandList.join("\n"),
//                                      textAlign: TextAlign.center,
//                                    )
//                                  : Container(),
//                            ),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      (widget.id.isEmpty || isEdit) && widget.bandId.isEmpty
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
                                        horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: _legalUserType == 0
                                            ? Color.fromRGBO(250, 177, 49, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _legalUserType == 0
                                                ? Color.fromRGBO(
                                                    244, 246, 248, 1.0)
                                                : Color.fromRGBO(
                                                    250, 177, 49, 1.0))),
                                    child: Text(
                                      'Age',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _legalUserType == 0
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: widget.id == true
                                      ? EdgeInsets.all(0)
                                      : EdgeInsets.all(4),
                                ),
                                InkWell(
                                  onTap: widget.id.isEmpty || isEdit
                                      ? () {
                                          _handleLegalUserValueChange(1);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: _legalUserType == 1
                                            ? Color.fromRGBO(250, 177, 49, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _legalUserType == 1
                                                ? Color.fromRGBO(
                                                    250, 177, 49, 1.0)
                                                : Color.fromRGBO(
                                                    250, 177, 49, 1.0))),
                                    child: Text(
                                      'Year',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _legalUserType == 1
                                            ? Colors.white
                                            : Colors.grey,
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
                              ? (widget.id.isEmpty || isEdit) &&
                                      widget.bandId.isEmpty
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
                                      : Container()
                              : Container(),
                          showYear == true
                              ? ((widget.id.isEmpty || isEdit) &&
                                      widget.bandId.isEmpty
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
                        padding: EdgeInsets.all(widget.bandId.isEmpty ? 5 : 0),
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
                          (widget.id.isEmpty || isEdit) && widget.bandId.isEmpty
                              ? Expanded(
                                  child: TextField(
                                    enabled: (widget.id.isEmpty || isEdit),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: _responseController,
                                    decoration: InputDecoration(
                                      labelText:
                                          "Write something about you experience",
                                      labelStyle: TextStyle(
                                        color: qDarkmodeEnable
                                            ? Colors.white
                                            : widget
                                                .appListener.primaryColorDark,
                                      ),
                                    ),
                                    maxLines: 2,
                                  ),
                                )
                              : _responseController.text.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child:
                                          Text("${_responseController.text}"),
                                    )
                                  : Container(),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.all(8),
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
                              ? "Select your Playing Style"
                              : "Playing Style",
                          style: textTheme.title.copyWith(
                            color:
                                qDarkmodeEnable ? Colors.white : Colors.black,
                          ),
                          textAlign: widget.id.isEmpty || isEdit
                              ? TextAlign.left
                              : TextAlign.center),

                      Padding(
                          padding:
                              EdgeInsets.all(widget.bandId.isEmpty ? 5 : 0)),
                      (widget.id.isEmpty || isEdit)
                          ? Wrap(
                              children: items,
                            )
                          : Text(
                              psList.join(", "),
                              textAlign: TextAlign.center,
                            ),

                      psList.contains("Other")
                          ? ((widget.id.isEmpty || isEdit))
                              ? TextField(
                                  enabled: (widget.id.isEmpty || isEdit),
                                  textCapitalization: TextCapitalization.words,
                                  controller: _playingStyleController,
                                  decoration: InputDecoration(
                                    labelText: "Enter Playing Style",
                                    labelStyle: TextStyle(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : widget.appListener.primaryColorDark,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    _playingStyleController.text,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : Container(),
                      Padding(
                          padding:
                              EdgeInsets.all(widget.bandId.isEmpty ? 5 : 0)),
//                      Text(
//                        "Instruments",
//                        style: textTheme.title.copyWith(
//                          color: Color.fromRGBO(124, 180, 97, 1.0),
//                        ),
//                        textAlign: widget.id.isEmpty || isEdit
//                            ? TextAlign.left
//                            : TextAlign.center,
//                      ),
//                      Padding(padding: EdgeInsets.all(5)),
//                      (widget.id.isEmpty || isEdit)
//                          ? Wrap(
//                              children: items2,
//                            )
//                          : Container(),
                      Padding(
                        padding: widget.id.isNotEmpty
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(widget.bandId.isEmpty ? 5 : 0),
                      ),
                      inList.length > 0
                          ? (widget.id.isEmpty || isEdit)
                              ? Text(
                                  "Select your expertise level :",
                                  textAlign: TextAlign.left,
                                  style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(255, 222, 3, 1.0)),
                                )
                              : Container()
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(widget.bandId.isEmpty ? 0 : 0),
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
                      Padding(
                          padding:
                              EdgeInsets.all(widget.bandId.isEmpty ? 0 : 5)),
                      Padding(
                          padding: EdgeInsets.all(
                              (widget.id.isEmpty || isEdit && widget.bandId.isEmpty) ? 5 : 0)),
                      Text(
                        "Experience",
                        textAlign: widget.id.isEmpty || isEdit
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.title.copyWith(
                            color:
                                qDarkmodeEnable ? Colors.white : Colors.black),
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      widget.id.isEmpty || isEdit
                          ? Wrap(
                              children: exps,
                            )
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    expss,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.all(widget.bandId.isEmpty?10:0),
                      ),
                      widget.id.isNotEmpty && isEdit
                          ? ShowUp(
                              child: new GestureDetector(
                                onTap: () {
                                  showBandExp(null);
                                },
                                child: widget.id.isNotEmpty && isEdit
                                    ? Text(
                                        "Click here to add band experience",
                                        style: textTheme.display1.copyWith(
                                            color: Colors.red, fontSize: 14),
                                      )
                                    : Container(),
                              ),
                              delay: 1000,
                            )
                          : Container(),
                      widget.id.isNotEmpty && isEdit
                          ? ShowUp(
                              child: Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.red,
                                margin: EdgeInsets.only(
                                    left: 0,
                                    right:
                                        MediaQuery.of(context).size.width / 2.4,
                                    top: 3,
                                    bottom: 0),
                              ),
                              delay: 1000,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(widget.bandId.isEmpty?5:0),
                      ),
                      (widget.id.isNotEmpty || isEdit)
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: bandDetails.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                BandDetails bandDetail = bandDetails[index];
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child:
                                                Text("${bandDetail.bandName}"),
                                          ),
                                          new Container(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  top: 0),
                                              alignment: Alignment.bottomCenter,
                                              child: Divider(
                                                color: Colors.black,
                                                height: 5,
                                                thickness: 1.5,
                                              )),
//                                  IconButton(
//                                    icon: Icon(Icons.edit),
//                                    onPressed: () {
//                                      showBandExp(bandDetail);
//                                    },
//                                  ),

                                          Text("${bandDetail.desc}"),
                                          Text(
                                              "${bandDetail.dateFrom}-${bandDetail.dateTo}"),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                          ),
//                              Container(
//                                child: null,
//                                width: MediaQuery.of(context).size.width,
//                                height: 1,
//                                color: Colors.grey,
//                              )
                                        ],
                                      ),
                                    ),
                                    isEdit
                                        ? IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              showBandExp(bandDetail);
                                            },
                                          )
                                        : Container(),
                                    isEdit
                                        ? IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              presenter.addBandExtra(bandDetail,
                                                  widget.id, false, true);
                                            },
                                          )
                                        : Container()
                                  ],
                                );
                              },
                            )
                          : Container(),
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
                        padding: EdgeInsets.all(0),
                      ),
                      (widget.id.isNotEmpty ) && !isEdit
                          ? _musicPreviewController.text.isNotEmpty
                              ? ShowUp(
                                  child: new GestureDetector(
                                    onTap: () {
                                      String url = _musicPreviewController.text;
                                      url = encodeStringToBase64UrlSafeString(
                                          url);
                                      widget.appListener.router.navigateTo(
                                          context,
                                          Screens.SHOWWEBURL.toString() +
                                              '/$url');
                                    },
                                    child: Text(
                                      "Click to hear music preview",
                                      style: textTheme.display1.copyWith(
                                          color: Colors.red, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  delay: 1000,
                                )
                              : Container()
                          : Container(),
                      (widget.id.isNotEmpty  && !isEdit)
                          ? _musicPreviewController.text.isNotEmpty
                              ? ShowUp(
                                  child: Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.red,
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                4.2,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                4.2,
                                        top: 3,
                                        bottom: 0),
                                  ),
                                  delay: 1000,
                                )
                              : Container()
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(widget.bandId.isEmpty?9:0),
                      ),
                      widget.bandId.isEmpty
                          ? ShowUp(
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
                                              style: textTheme.display1
                                                  .copyWith(
                                                      color: qDarkmodeEnable
                                                          ? Colors.white
                                                          : widget.appListener
                                                              .primaryColorDark,
                                                      fontSize: 14),
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              delay: 1000,
                            )
                          : Container(),
                      isEducation && widget.bandId.isEmpty
                          ? Text(
                              "Education",
                              textAlign: widget.id.isEmpty || isEdit
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.title.copyWith(
                                  color: qDarkmodeEnable
                                      ? Colors.white
                                      : Colors.black),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(widget.bandId.isEmpty ? 1 : 0),
                      ),
                      (widget.id.isEmpty || isEdit) && widget.bandId.isEmpty
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              textCapitalization: TextCapitalization.words,
                              controller: _listSchoolController,
                              /**/ decoration: InputDecoration(
                                labelText: "List School",
                                labelStyle: TextStyle(
                                  color: qDarkmodeEnable
                                      ? Colors.white
                                      : widget.appListener.primaryColorDark,
                                ),
                              ),
                            )
                          : widget.bandId.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
//                                    Expanded(
//                                      flex: 5,
//                                      child: Text(
//                                        "School",
//                                        textAlign: TextAlign.right,
//                                        style: textTheme.subtitle.copyWith(),
//                                      ),
//                                    ),
//                                    Expanded(
//                                      flex: 1,
//                                      child: Text(
//                                        " - ",
//                                        textAlign: TextAlign.center,
//                                      ),
//                                    ),
                                    Center(
                                      child: Text(
                                        _listSchoolController.text,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                      Padding(padding: EdgeInsets.all(widget.id.isEmpty||isEdit && widget.bandId.isEmpty?4:0),),
                      isEducation
                          ? (widget.id.isEmpty || isEdit) &&
                                  widget.bandId.isEmpty
                              ? DropdownButton<String>(
                                  items: education.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: qDarkmodeEnable
                                                ? Colors.white
                                                : widget.appListener
                                                    .primaryColorDark),
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
                      widget.bandId.isEmpty?Column(
                        children: <Widget>[
                          (widget.id.isEmpty || isEdit) && widget.bandId.isEmpty
                              ? TextField(
                                  enabled: widget.id.isEmpty || isEdit,
                                  controller: _earnController,
                                  decoration: InputDecoration(
                                    labelText:
                                        "What did you earn your academic degree in",
                                    labelStyle: TextStyle(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : widget.appListener.primaryColorDark,
                                    ),
                                  ),
                                )
                              : widget.bandId.isEmpty
                                  ? Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            selectedEducation ?? "",
                                            textAlign: TextAlign.right,
                                            style:
                                                textTheme.subtitle.copyWith(),
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
                                            _earnController.text,
                                            textAlign: TextAlign.left,
                                          ),
                                          flex: 5,
                                        )
                                      ],
                                    )
                                  : Container(),
                          Container(),
                        ],
                      ):Container(),
                      Padding(
                        padding: EdgeInsets.all(widget.bandId.isEmpty ? 0 : 5),
                      ),
                      //                      widget.id.isEmpty || isEdit
                      //                          ? Container()
                      //                          : widget.bandId.isNotEmpty
                      //                              ? Text(
                      //                                  "Band Contact Info",
                      //                                  textAlign: TextAlign.center,
                      //                                  style: textTheme.title.copyWith(
                      //                                    fontSize: 19,
                      //                                    color: Color.fromRGBO(124, 180, 97, 1.0),
                      //                                  ),
                      //                                )
                      //                              : Container(),
                      //                      widget.bandId.isNotEmpty
                      //                          ? (widget.id.isEmpty || isEdit)
                      //                              ? Container()
                      //                              : Padding(
                      //                                  padding: EdgeInsets.symmetric(vertical: 4),
                      //                                  child: Text(
                      //                                    "${_nameBandController.text} - ${_contactBandController.text}",
                      //                                    textAlign: TextAlign.center,
                      //                                  ),
                      //                                )
                      //                          : Container(),
                      // widget.bandId.isNotEmpty
                      //     ? (widget.id.isEmpty || isEdit)
                      //         ? TextField(
                      //             controller: _emailBandController,
                      //             decoration: InputDecoration(
                      //               hintText: "Band Email",
                      //             ),
                      //           )
                      //         : Padding(
                      //             padding: EdgeInsets.symmetric(vertical: 4),
                      //             child: Text(
                      //               _emailBandController.text,
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           )
                      //     : Container(),
                      Padding(padding: EdgeInsets.all(widget.bandId.isEmpty?5:0),),
                       (widget.id.isEmpty || isEdit)
                          ? TextField(
                              controller: _musicPreviewController,
                              decoration: InputDecoration(
                                hintText: "Hyperlink to your Music",
                                errorText: _errorMusic,
                                prefixText:_musicPreviewController.text.isEmpty? "https://":"",

                              ),
                              style: TextStyle(
                                  color: qDarkmodeEnable
                                      ? Colors.white
                                      : Colors.black87),
                         onChanged: (text){
                                setState(() {

                                });
                         },
                            )
                          : Container(),

                      widget.bandId.isNotEmpty
                          ? (widget.id.isEmpty || isEdit)
                              ? TextField(
                                  controller: _websiteBandController,
                                  decoration: InputDecoration(
                                    hintText: "Band Website",
                                  ),
                                  style: TextStyle(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black87),
                                )
                              : Padding(
                                  child: Text(
                                    _websiteBandController.text,
                                    textAlign: TextAlign.center,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      (widget.bandId.isNotEmpty)
                          ? (widget.id.isEmpty || isEdit)
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: aboutBandList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final _aboutBandsController =
                                        TextEditingController();
                                    _aboutBandsController.text =
                                        aboutBandList[index];
                                    _aboutBandsController.addListener(() {
                                      aboutBandList[index] =
                                          _aboutBandsController.text;
                                    });
                                    return TextField(
                                      controller: _aboutBandsController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          hintText:
                                              "About the band ${index + 1}",
                                          prefixIcon: aboutBandList.length > 0
                                              ? IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    if (aboutBandList.length >
                                                        0) {
                                                      setState(() {
                                                        aboutBandList
                                                            .removeAt(index);
                                                      });
                                                    }
                                                  },
                                                )
                                              : null,
                                          suffixIcon: aboutBandList.length < 3
                                              ? IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    if (aboutBandList.length <
                                                        3) {
                                                      setState(() {
                                                        aboutBandList.add("");
                                                      });
                                                    }
                                                  },
                                                )
                                              : null),
                                      style: TextStyle(
                                          color: qDarkmodeEnable
                                              ? Colors.white
                                              : Colors.black87),
                                      maxLength: 50,
                                      maxLines: 1,
                                    );
                                  },
                                )
                              : Container()
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      RaisedButton(
                        color: Color.fromRGBO(250, 177, 49, 1.0),
                        child: Text("Set-List"),
                        onPressed: () {
                          widget.appListener.router.navigateTo(context,
                              Screens.SETLIST.toString() + "/${widget.id}");
                        },
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
                                if (_musicPreviewController.text.isNotEmpty &&
                                    !checkvalid(_musicPreviewController.text)) {
                                  _errorMusic = "Not a valid URL";
                                } else {
                                  _submitEPK();
                                }
                              },
                              child: Text(
                                "Submit",
                                style: TextStyle(color: Colors.black),
                              ),
                              color: Color.fromRGBO(250, 177, 49, 1.0),
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

  //added image cropper in the code
  Future<Null> _cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      image = croppedFile;
      setState(() {
        // _image = image;
        files.clear();
        files.add(image.path);
      });
    }
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
                _cropImage(image);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                _cropImage(image);
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
      isEdit = !isEdit;
    });
    showMessage("Updated Successfully");
  }

  @override
  void onDetailsSuccess(UserPlayingStyle userPlayingStyle) {
    hideLoading();
    setState(() {
      files.clear();
      files.addAll(userPlayingStyle.files);
      aboutBandList = userPlayingStyle.aboutTheBands;
      _aboutBandController.text = userPlayingStyle.about;
      _otherExpController.text = userPlayingStyle.otherExp;
      _degreeController.text = userPlayingStyle.degree;
      _earnController.text = userPlayingStyle.earn;
      _expController.text = userPlayingStyle.viewerKnow;
      _listSchoolController.text = userPlayingStyle.listSchool;
      _roleController.text = userPlayingStyle.role;
      _responseController.text = userPlayingStyle.response;
      _yearController.text = userPlayingStyle.year;
      _ageController.text = userPlayingStyle.age;
      _aboutBandController.text = userPlayingStyle.aboutBand;
      _emailBandController.text = userPlayingStyle.bandEmail;
      _nameBandController.text = userPlayingStyle.bandName;
      _contactBandController.text = userPlayingStyle.bandContacts;
      _websiteBandController.text = userPlayingStyle.bandWebsite;
      _musicPreviewController.text = userPlayingStyle.musicpreview;
      isEducation = true;
      bandDetails = userPlayingStyle.bandDetails;

      for (String item in userPlayingStyle.experience) {
        exList[item] = null;
      }
      selectedEducation = userPlayingStyle.education ?? "";
      if (userPlayingStyle.age != null) {
        isyearage = 0;
        showage = true;
        _legalUserType = 0;
      } else if (userPlayingStyle.year != null) {
        isyearage = 1;
        showYear = true;
        _legalUserType = 1;
      } else if (userPlayingStyle.response != null) {
        isyearage = 2;
      }
      psList.clear();
      psList.addAll(userPlayingStyle.playing_styles);
      inList.clear();
      inList.addAll(userPlayingStyle.instruments);
      _playingStyleController.text = userPlayingStyle.playingStyle;
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
      _bandCity = res.city;
      _bandState = res.state;
    });
  }

  @override
  void onUserDetailsSuccess(User res) {
    setState(() {
      user = res;
    });
  }

  @override
  void addBandExtra(bool isDelete) {
    if (!isDelete) Navigator.pop(context);
    presenter.getPlayingStyleDetails(widget.id);
  }

  void showBandExp(BandDetails bandDetail) {
    if (bandDetail != null) {
      _bandNameController.text = bandDetail.bandName;
      _descController.text = bandDetail.desc;
      _yearFromController.text = bandDetail.dateFrom;
      _yearToController.text = bandDetail.dateTo;
    } else {
      _bandNameController.clear();
      _descController.clear();
      _yearToController.clear();
      _yearFromController.clear();
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Information'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: _bandNameController,
                  decoration:
                      InputDecoration(hintText: "Name of Band, Program, etc."),
                ),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(hintText: "Description"),
                ),
                TextField(
                  controller: _yearFromController,
                  decoration: InputDecoration(hintText: "Year From"),
                ),
                TextField(
                  controller: _yearToController,
                  decoration: InputDecoration(hintText: "Year To"),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  bool isUpdate = true;
                  if (bandDetail == null) {
                    isUpdate = false;
                    bandDetail = BandDetails();
                  }
                  if (bandDetail.id == null) {
                    bandDetail.id = randomString(18).replaceAll(",/\\", "");
                  }
                  bandDetail.bandName = _bandNameController.text;
                  bandDetail.desc = _descController.text;
                  bandDetail.dateTo = _yearToController.text;
                  bandDetail.dateFrom = _yearFromController.text;
                  presenter.addBandExtra(
                      bandDetail, widget.id, isUpdate, false);
                },
              )
            ],
          );
        });
  }

  _submitEPK() {
    showLoading();
    presenter.addPlayingStyle(UserPlayingStyle(
        instruments: inList,
        id: widget.id,
        role: _roleController.text,
        bandId: widget.bandId,
        aboutTheBands: aboutBandList,
        degree: _degreeController.text,
        response: _responseController.text,
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
        age: showage == true ? _ageController.text : null,
        year: showYear == true ? _yearController.text : null,
        experience: List.from(exList.keys),
        listSchool: _listSchoolController.text,
        playingStyle: _playingStyleController.text,
        viewerKnow: _expController.text,
        musicpreview: "https://${_musicPreviewController.text}",
        files: files));
  }

  bool checkvalid(String text) {
    var urlPattern =
        r"([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    bool match = new RegExp(urlPattern, caseSensitive: false).hasMatch(text);
    if (match) {
      return true;
    }
    return false;
  }
}
