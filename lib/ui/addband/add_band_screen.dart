import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/ui/addband/add_band_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddBandScreen extends BaseScreen {
  final String id;
  AddBandScreen(AppListener appListener, {this.id}) : super(appListener);

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
      _bandResponsibilitiesController = TextEditingController(),
      _legalStructureController = TextEditingController(),
      _zipController = TextEditingController(),
      _emailController = TextEditingController(),
      _websiteController = TextEditingController();
  String _errorDateStarted, _errorMusicStyle, _errorStructure, _errorWebsite;
  String _errorBandName,
      _errorBandLegalName,
      _errorBandResponsibility,
      _errorEmail;

  File _image;

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
  Widget buildBody() {
    return Container(
        color: Color.fromRGBO(240, 243, 244, 0.5),
        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Align(
                child: Text(
                  "${widget.id.isEmpty ? "Add " : ""}Band",
                  style: textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                padding: EdgeInsets.all(20),
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
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _bandNameController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelText: "Enter Band Name",
                        errorText: _errorBandName),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _bandlegalNameController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelText: "Enter Band Legal Name",
                        errorText: _errorBandLegalName),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _legalStructureController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelText: "Enter Legal Structure",
                        errorText: _errorStructure),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  InkWell(
                    child: AbsorbPointer(
                      child: TextField(
                        enabled: widget.id.isEmpty,
                        controller: _dateStartedController,
                        decoration: InputDecoration(
                            labelText: "Enter Date Started",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            errorText: _errorDateStarted),
                      ),
                    ),
                    onTap: () {
                      if (widget.id.isEmpty) _selectDate(context, true);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _musicStyleController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelText: "Enter Music Style",
                        errorText: _errorMusicStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _bandResponsibilitiesController,
                    decoration: InputDecoration(
                        labelText: "Enter Band Responsibility",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorText: _errorBandResponsibility),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _websiteController,
                    decoration: InputDecoration(
                      labelText: "Enter Website",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      errorText: _errorWebsite,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  TextField(
                    enabled: widget.id.isEmpty,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Enter Email Address",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      errorText: _errorEmail,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                  ),
                  widget.id.isEmpty
                      ? RaisedButton(
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              String dateStarted = _dateStartedController.text;
                              String musicStyle = _musicStyleController.text;
                              String bname = _bandNameController.text;
                              String blname = _bandlegalNameController.text;
                              String legalstructure =
                                  _legalStructureController.text;
                              String bandRes =
                                  _bandResponsibilitiesController.text;
                              String email = _emailController.text;
                              String website = _websiteController.text;
                              _errorBandLegalName = null;
                              _errorBandName = null;
                              _errorBandResponsibility = null;
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
                              } else if (bandRes.isEmpty) {
                                _errorBandResponsibility = "Cannot be empty";
                              } else if (website.isEmpty) {
                                _errorWebsite = "Cannot be empty";
                              } else {
                                showLoading();
                                presenter.addBand(
                                    dateStarted,
                                    musicStyle,
                                    bname,
                                    blname,
                                    legalstructure,
                                    bandRes,
                                    email,
                                    website);
                              }
                            });
                          },
                          child: Text("Add"),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.all(10),
                  )
                ],
              ),
            ),
          )
        ]));
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
      _bandResponsibilitiesController.clear();
      _emailController.clear();
      _websiteController.clear();
      _errorBandLegalName = null;
      _errorBandName = null;
      _errorBandResponsibility = null;
      _errorDateStarted = null;
      _errorEmail = null;
      _errorMusicStyle = null;
      _errorStructure = null;
      _errorWebsite = null;
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
  void getBandDetails(Band band) {
    hideLoading();
    setState(() {
      _musicStyleController.text = band.musicStyle;
      _bandlegalNameController.text = band.legalName;
      _bandNameController.text = band.name;
      _bandResponsibilitiesController.text = band.responsbilities;
      _emailController.text = band.email;
      _legalStructureController.text = band.legalStructure;
      _websiteController.text = band.website;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(band.dateStarted));
      _dateStartedController.text =
          formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
    });
  }
}
