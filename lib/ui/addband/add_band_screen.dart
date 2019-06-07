import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addband/add_band_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddBandScreen extends BaseScreen {
  AddBandScreen(AppListener appListener) : super(appListener);

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
                  "Add Band",
                  style: textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Next",
                      style: textTheme.button,
                    ),
                  ),
                  onTap: () {
                    widget.appListener.router.navigateTo(
                      context,
                      Screens.ADDINSTRUMENT.toString(),
                      replace: true,
                      transition: TransitionType.inFromRight,
                    );
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  InkWell(
                    child: Center(
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: _image != null
                            ? new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(_image),
                                ),
                              )
                            : null,
                        child: _image == null
                            ? Icon(
                                Icons.account_circle,
                                size: 100,
                              )
                            : null,
                      ),
                    ),
                    onTap: getImage,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Band Name",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _bandNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Band Name",
                        errorText: _errorBandName),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Band Legal Name",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _bandlegalNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Band Legal Name",
                        errorText: _errorBandLegalName),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Legal Structure",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _legalStructureController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Legal Structure",
                        errorText: _errorStructure),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Date Started",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _dateStartedController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Date Started",
                        errorText: _errorDateStarted),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Music Style",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _musicStyleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Music Style",
                        errorText: _errorMusicStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Band Responsibility",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _bandResponsibilitiesController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Band Responsibility",
                        errorText: _errorBandResponsibility),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Website",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _websiteController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Website",
                        errorText: _errorWebsite),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Email Address",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter Email Address",
                        errorText: _errorEmail),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                  ),
                  RaisedButton(
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
                        String legalstructure = _legalStructureController.text;
                        String bandRes = _bandResponsibilitiesController.text;
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
                          presenter.addBand(dateStarted, musicStyle, bname,
                              blname, legalstructure, bandRes, email, website);
                        }
                      });
                    },
                    child: Text("Add"),
                  ),
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
}
