import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/ui/addband/add_band_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddBandScreen extends BaseScreen {
  final String id;

  AddBandScreen(AppListener appListener, {this.id})
      : super(appListener, title: "${id.isEmpty ? "Add" : ""} Band");

  @override
  _AddBandScreenState createState() => _AddBandScreenState();
}

class _AddBandScreenState
    extends BaseScreenState<AddBandScreen, AddBandPresenter>
    implements AddBandContract {
  final _dateStartedController = TextEditingController(),
      _musicStyleController = TextEditingController(),
      _bandNameController = TextEditingController(),
      _bandlegalNameController = TextEditingController(),
      _structureController = TextEditingController(),
      _legalStructureController = TextEditingController(),
      _zipController = TextEditingController(),
      _emailController = TextEditingController(),
      _websiteController = TextEditingController();
  String _errorDateStarted, _errorMusicStyle, _errorStructure, _errorWebsite;
  String _errorBandName, _errorBandLegalName, _errorEmail;
  List<User> members = [];
  final legalStructure = [
    "Corporation",
    "LLC",
    "Partnership",
    "S Corp",
    "Sole Proprietor",
    "Other"
  ];

  File _image;
  var _legalUserType;
  bool isEdit = false;
  bool showLegalName = false;
  var _structuretype = "Corporation";

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
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                setState(() {
                  _image = image;
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
                  _image = image;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getBandDetails(widget.id);
      });
    }
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(135, 67, 125, 1.0),
        actions: <Widget>[
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                )
        ],
      );

  void _handleLegalUserValueChange(int value) {
    setState(() {
      _legalUserType = value;
      if (_legalUserType == 1) {
        _bandlegalNameController.text = "";
        showLegalName = false;
      } else if (_legalUserType == 0) {
        showLegalName = true;
      }
    });
  }

  void _handleStructureValueChange(String value) {
    setState(() {
      _structuretype = value;
      _legalStructureController.text = value;
    });
  }

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(135, 67, 125, 1.0),
            height: height / 2.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.id.isEmpty ? "Add" : isEdit ? "Edit" : ""} Band",
                style: textTheme.display1.copyWith(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: ListView(
                    padding: EdgeInsets.all(30),
                    children: <Widget>[
                      // InkWell(
                      //   child: Center(
                      //     child: Container(
                      //       width: 150.0,
                      //       height: 150.0,
                      //       decoration: _image != null
                      //           ? new BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               image: new DecorationImage(
                      //                 fit: BoxFit.fill,
                      //                 image: FileImage(_image),
                      //               ),
                      //             )
                      //           : null,
                      //       child: _image == null
                      //           ? Icon(
                      //               Icons.account_circle,
                      //               size: 100,
                      //             )
                      //           : null,
                      //     ),
                      //   ),
                      //   onTap: getImage,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(20),
                      // ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Band Name",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead,
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _bandNameController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Band Name",
                                errorText: _errorBandName,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              _bandNameController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            widget.id.isEmpty || isEdit
                                ? Text("Has legal name?")
                                : Container(),
                            Padding(
                              padding: EdgeInsets.all(3),
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
                                                  ? Color.fromRGBO(
                                                      209, 244, 236, 1.0)
                                                  : Color.fromRGBO(
                                                      244, 246, 248, 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: _legalUserType == 0
                                                      ? Color.fromRGBO(
                                                          70, 206, 172, 1.0)
                                                      : Color.fromRGBO(
                                                          244, 246, 248, 1.0))),
                                          child: Text(
                                            'Yes',
                                            style: new TextStyle(
                                              fontSize: 16.0,
                                              color: _legalUserType == 0
                                                  ? Color.fromRGBO(
                                                      70, 206, 172, 1.0)
                                                  : Color.fromRGBO(
                                                      202, 208, 215, 1.0),
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
                                                  ? Color.fromRGBO(
                                                      209, 244, 236, 1.0)
                                                  : Color.fromRGBO(
                                                      244, 246, 248, 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: _legalUserType == 1
                                                      ? Color.fromRGBO(
                                                          70, 206, 172, 1.0)
                                                      : Color.fromRGBO(
                                                          244, 246, 248, 1.0))),
                                          child: Text(
                                            'No',
                                            style: new TextStyle(
                                              fontSize: 16.0,
                                              color: _legalUserType == 1
                                                  ? Color.fromRGBO(
                                                      70, 206, 172, 1.0)
                                                  : Color.fromRGBO(
                                                      202, 208, 215, 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),

                      showLegalName
                          ? widget.id.isEmpty || isEdit
                              ? Container()
                              : Text(
                                  "Band Legal Name",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead,
                                )
                          : Container(),
                      showLegalName
                          ? widget.id.isEmpty || isEdit
                              ? TextField(
                                  enabled: widget.id.isEmpty ||
                                      isEdit && (_legalUserType == 0),
                                  controller: _bandlegalNameController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    labelText: "Band Legal Name",
                                    errorText: _errorBandLegalName,
                                    border: widget.id.isEmpty || isEdit
                                        ? null
                                        : InputBorder.none,
                                  ),
                                )
                              : Text(
                                  _bandlegalNameController.text,
                                  textAlign: TextAlign.center,
                                )
                          : Container(),
                      showLegalName
                          ? Padding(
                              padding: EdgeInsets.all(5),
                            )
                          : Container(),
                      showLegalName
                          ? widget.id.isEmpty || isEdit
                              ? Text(
                                  "Legal Structure",
                                  textAlign: TextAlign.left,
                                  style: textTheme.subhead,
                                )
                              : Text(
                                  "Legal Structure",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead,
                                )
                          : Container(),
                      showLegalName
                          ? widget.id.isEmpty || isEdit
                              ? Container(
                                  child: DropdownButton<String>(
                                    items: legalStructure.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: _handleStructureValueChange,
                                    value: _structuretype,
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Container()
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      _structuretype == "Other" &&
                              (widget.id.isNotEmpty || isEdit)
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              controller: _legalStructureController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: widget.id.isNotEmpty ? "" : "Other",
                                errorText: _errorStructure,
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Container(),

                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Date Started",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead,
                            ),
                      widget.id.isEmpty || isEdit
                          ? InkWell(
                              child: AbsorbPointer(
                                child: TextField(
                                  enabled: widget.id.isEmpty,
                                  controller: _dateStartedController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    labelText: "Date Started",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    errorText: _errorDateStarted,
                                    border: widget.id.isEmpty
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (widget.id.isEmpty || isEdit)
                                  _selectDate(context, true);
                              },
                            )
                          : Text(
                              _dateStartedController.text,
                              textAlign: TextAlign.center,
                            ),
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                      ),
//                      widget.id.isEmpty || isEdit
//                          ? Container()
//                          : Text(
//                              "Music Style",
//                              textAlign: TextAlign.center,
//                              style: textTheme.subhead,
//                            ),
//                      widget.id.isEmpty || isEdit
//                          ? TextField(
//                              enabled: widget.id.isEmpty || isEdit,
//                              controller: _musicStyleController,
//                              textCapitalization: TextCapitalization.sentences,
//                              decoration: InputDecoration(
//                                labelStyle: TextStyle(
//                                  color: Color.fromRGBO(202, 208, 215, 1.0),
//                                ),
//                                labelText: "Music Style",
//                                errorText: _errorMusicStyle,
//                                border: widget.id.isEmpty || isEdit
//                                    ? null
//                                    : InputBorder.none,
//                              ),
//                              style: textTheme.subhead.copyWith(
//                                color: Colors.black,
//                              ),
//                            )
//                          : Text(
//                              _musicStyleController.text,
//                              textAlign: TextAlign.center,
//                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Website",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead,
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _websiteController,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Website",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorWebsite,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                          : Text(
                              _websiteController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Email Address",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead,
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _emailController,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorEmail,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                          : Text(
                              _emailController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              "Add Bandmates",
                              textAlign: TextAlign.left,
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                        ),
                      ),
                      widget.id.isEmpty
                          ? Container()
                          : Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Members(${members.length})",
                                    style: textTheme.subhead.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                widget.id.isEmpty || isEdit
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: widget.appListener.accentColor,
                                        ),
                                        onPressed: () async {
                                          final res = await widget
                                              .appListener.router
                                              .navigateTo(
                                                  context,
                                                  Screens.ADDMEMBERTOBAND
                                                          .toString() +
                                                      "/${widget.id}");
                                          if (res != null &&
                                              res['user_id'] != null) {
                                            String userId = res['user_id'];
                                            if (members != null) {
                                              User user =
                                                  members.firstWhere((u) {
                                                return u.id == userId;
                                              });
                                              if (user != null) {
                                                showMessage(
                                                    "User already a member");
                                              } else {
                                                presenter.addMemberToBand(
                                                    widget.id, res['user_id']);
                                              }
                                            }
                                          }
                                          // presenter.getBandDetails(widget.id);
                                        })
                                    : Container()
                              ],
                            ),
                      widget.id.isEmpty
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: members.length,
                              itemBuilder: (BuildContext context, int index) {
                                User user = members[index];
                                return ListTile(
                                  title: Text(
                                    "${user.firstName} ${user.lastName}",
                                    style: textTheme.subhead.copyWith(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${user.primaryInstrument}",
                                    style: textTheme.subhead.copyWith(
                                      color: Color.fromRGBO(135, 67, 125, 1.0),
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                      widget.id.isEmpty
                          ? RaisedButton(
                              color: Color.fromRGBO(135, 67, 125, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  String dateStarted =
                                      _dateStartedController.text;
                                  String musicStyle =
                                      _musicStyleController.text;
                                  String bname = _bandNameController.text;
                                  String blname = _bandlegalNameController.text;
                                  String legalstructure =
                                      _legalStructureController.text;
                                  String email = _emailController.text;
                                  String website = _websiteController.text;
                                  _errorBandLegalName = null;
                                  _errorBandName = null;
                                  _errorDateStarted = null;
                                  _errorEmail = null;
                                  _errorMusicStyle = null;
                                  _errorStructure = null;
                                  _errorWebsite = null;
                                  if (bname.isEmpty) {
                                    _errorBandName = "Cannot be empty";
                                  } else if (blname.isEmpty) {
                                    _errorBandLegalName = "Cannot be empty";
                                  } else if (dateStarted.isEmpty) {
                                    _errorDateStarted = "Cannot be empty";
                                  } else if (musicStyle.isEmpty) {
                                    _errorMusicStyle = "Cannot be empty";
                                  } else if (email.isEmpty) {
                                    _errorEmail = "Cannot be empty";
                                  } else if (validateEmail(email)) {
                                    _errorEmail = "Not a Valid Email";
                                  } else if (musicStyle.isEmpty) {
                                    _errorMusicStyle = "Cannot be empty";
                                  } else if (legalstructure.isEmpty) {
                                    _errorStructure = "Cannot be empty";
                                  } else if (website.isEmpty) {
                                    _errorWebsite = "Cannot be empty";
                                  } else {
                                    showLoading();
                                    presenter.addBand(
                                        selectedStartDate
                                            .millisecondsSinceEpoch,
                                        musicStyle,
                                        bname,
                                        blname,
                                        legalstructure,
                                        email,
                                        website,
                                        id: widget.id);
                                  }
                                });
                              },
                              child: Text("Submit"),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(10),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  AddBandPresenter get presenter => AddBandPresenter(this);

  @override
  void addBandSuccess() {
    hideLoading();
    showMessage("Add Band Successfully");
    setState(() {
      _dateStartedController.clear();
      _musicStyleController.clear();
      _bandNameController.clear();
      _bandlegalNameController.clear();
      _legalStructureController.clear();
      _emailController.clear();
      _websiteController.clear();
      _errorBandLegalName = null;
      _errorBandName = null;
      _errorDateStarted = null;
      _errorEmail = null;
      _errorMusicStyle = null;
      _errorStructure = null;
      _errorWebsite = null;
    });
    Timer timer = new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  DateTime selectedStartDate = DateTime.now(), selectedEndDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context, bool isStart) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate)
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
          _dateStartedController.text =
              formatDate(selectedStartDate, [mm, '-', dd, '-', yy]);
        } else {
          selectedEndDate = picked;
          _dateStartedController.text =
              formatDate(selectedEndDate, [mm, '-', dd, '-', yy]);
        }
      });
  }

  @override
  void getBandDetails(Band band) async {
    hideLoading();
    setState(() {
      _musicStyleController.text = band.musicStyle;
      _bandlegalNameController.text = band.legalName;
      _bandNameController.text = band.name;
      _emailController.text = band.email;
      _legalStructureController.text = band.legalStructure;
      _websiteController.text = band.website;
      _legalUserType = (band.legalName?.isEmpty ?? false) ? 1 : 0;
      showLegalName = _legalUserType == 0 ? true : false;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(band.dateStarted);
      _dateStartedController.text =
          formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
      members.addAll(band.bandmateUsers);
    });
  }

  @override
  void onUpdate() {
    showLoading();
    presenter.getBandDetails(widget.id);
  }
}
