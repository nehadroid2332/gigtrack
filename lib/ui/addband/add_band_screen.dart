import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/ui/addband/add_band_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
      _bandCityController = TextEditingController(),
      _bandStateController = TextEditingController(),
      _bandZipController = TextEditingController(),
      _bandlegalNameController = TextEditingController(),
      // _structureController = TextEditingController(),
      _legalStructureController = TextEditingController(),
      // _zipController = TextEditingController(),
      _emailController = TextEditingController(),
      _websiteController = TextEditingController();
  String _errorDateStarted, _errorMusicStyle, _errorStructure, _errorWebsite;
  List files = <String>[];
  String _errorBandName,
      _errorBandCity,
      _errorBandZip,
      _errorBandState,
      _errorBandLegalName,
      _errorEmail;
  List<BandMember> members = [];
  User user;
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

  String bandUserId;

  Map<String, BandMember> bandmates = {};

  String userPlayingStyleId;

  String primaryContactEmail;

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
        _image = image;
        files.clear();
        files.add(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    presenter.getPlayingStyleList(widget.id);
    presenter.getUserProfile();
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
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
                  presenter.deleteBand(widget.id);
                  //Navigator.of(context).pop();
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      Screens.BANDLIST.toString() + "/////"));
                }
              },
            ),
          ],
        );
      },
    );
  }

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
    bool permission = false;
    String permissionType;
    if (members != null && members.length > 0) {
      for (var item in members) {
        if (item.email == presenter.serverAPI.currentUserEmail) {
          permissionType = item.permissions;
        }
        if (item.permissions == "Leader" || item.permissions == "Setup") {
          permission = (item.email == presenter.serverAPI.currentUserEmail);
        }
      }
    }
    if (permissionType == null) {
      if (bandUserId == presenter.serverAPI.currentUserId) {
        permissionType = "Leader";
      }
    }

    List<Widget> contactInfo = [];
    for (var mem in members) {
      if (mem.email == primaryContactEmail) {
        final formatter = new NumberFormat("#,###");
        contactInfo.add(Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                "${mem.firstName} ${mem.lastName}",
                textAlign: TextAlign.right,
              ),
            ),
            Text(" - "),
            Expanded(
              flex: 1,
              child: Text("${mem.mobileText ?? 'No Contact Added'}"),
            ),
            mem.email == primaryContactEmail
                ? Icon(Icons.account_circle)
                : Container()
          ],
        ));
      }
    }
    if (contactInfo.length < 1) {
      contactInfo.add(Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: user != null
                ? Text(
                    "${user.firstName} ${user.lastName}",
                    textAlign: TextAlign.right,
                  )
                : Container(),
          ),
          Text(" - "),
          Expanded(
            flex: 1,
            child: user != null
                ? Text("${user.phone ?? 'No Contact Added'}")
                : Container(),
          ),
        ],
      ));
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedClipper(height / 2.5),
            child: Container(
              color: Color.fromRGBO(239, 181, 77, 1.0),
              height: height / 2.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 0,
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
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),

                        widget.id.isEmpty || isEdit ? Container() : Container(),
                        //                        Text(
                        //                                "Name",
                        //                                textAlign: TextAlign.center,
                        //                                style: textTheme.subhead
                        //                                    .copyWith(fontWeight: FontWeight.w600),
                        //
                        //                              ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : files != null && files.length > 0
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    height: MediaQuery.of(context).size.height /
                                        4.4,
                                    width: 90,
                                    child: Image.network(
                                      File(files[0]).path,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        widget.id.isEmpty || isEdit
                            ? TextField(
                                enabled: widget.id.isEmpty || isEdit,
                                textCapitalization: TextCapitalization.words,
                                controller: _bandNameController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                  ),
                                  labelText: "Name",
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
                                style: textTheme.subtitle.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),

                        Padding(
                          padding: EdgeInsets.all(1),
                        ),
                        widget.id.isEmpty || isEdit ? Container() : Container(),
                        //                        Text(
                        //                                "City",
                        //                                textAlign: TextAlign.center,
                        //                                style: textTheme.subhead
                        //                                    .copyWith(fontWeight: FontWeight.w600),
                        //                              ),
                        //Padding(padding: EdgeInsets.all(3),),
                        widget.id.isEmpty || isEdit
                            ? TextField(
                                enabled: widget.id.isEmpty || isEdit,
                                textCapitalization: TextCapitalization.words,
                                controller: _bandCityController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                  ),
                                  labelText: "City",
                                  errorText: _errorBandCity,
                                  border: widget.id.isEmpty || isEdit
                                      ? null
                                      : InputBorder.none,
                                ),
                                style: textTheme.subhead.copyWith(
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                "${_bandCityController.text} , ${_bandStateController.text}",
                                textAlign: TextAlign.center,
                              ),
                        //  Padding(padding: EdgeInsets.all(5),),
                        widget.id.isEmpty || isEdit ? Container() : Container(),
                        //                        Text(
                        //                                "State",
                        //                                textAlign: TextAlign.center,
                        //                                style: textTheme.subhead
                        //                                    .copyWith(fontWeight: FontWeight.w600),
                        //                              ),
                        // Padding(padding: EdgeInsets.all(3),),
                        widget.id.isEmpty || isEdit
                            ? TextField(
                                enabled: widget.id.isEmpty || isEdit,
                                textCapitalization: TextCapitalization.words,
                                controller: _bandStateController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                  ),
                                  labelText: "State",
                                  errorText: _errorBandState,
                                  border: widget.id.isEmpty || isEdit
                                      ? null
                                      : InputBorder.none,
                                ),
                                style: textTheme.subhead.copyWith(
                                  color: Colors.black,
                                ),
                              )
                            : Container(),
                        //                        Text(
                        //                          _bandStateController.text,
                        //                          textAlign: TextAlign.center,
                        //                        ),
                        //  Padding(padding: EdgeInsets.all(5),),
                        widget.id.isEmpty || isEdit ? Container() : Container(),
                        //                        Text(
                        //                                "ZIP",
                        //                                textAlign: TextAlign.center,
                        //                                style: textTheme.subhead
                        //                                    .copyWith(fontWeight: FontWeight.w600),
                        //                              ),
                        //Padding(padding: EdgeInsets.all(3),),
                        widget.id.isEmpty || isEdit
                            ? TextField(
                                enabled: widget.id.isEmpty || isEdit,
                                textCapitalization: TextCapitalization.words,
                                controller: _bandZipController,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                  ),
                                  labelText: "ZIP",
                                  errorText: _errorBandZip,
                                  border: widget.id.isEmpty || isEdit
                                      ? null
                                      : InputBorder.none,
                                ),
                                style: textTheme.subhead.copyWith(
                                  color: Colors.black,
                                ),
                              )
                            : Container(),
                        //                        Text(
                        //                          _bandZipController.text,
                        //                          textAlign: TextAlign.center,
                        //                        ),
                        widget.id.isEmpty || isEdit ? Container() : Container(),
                        //                        Text(
                        //                                "Date Established",
                        //                                textAlign: TextAlign.center,
                        //                                style: textTheme.subhead
                        //                                    .copyWith(fontWeight: FontWeight.w600),
                        //                              ),
                        Padding(
                          padding: EdgeInsets.all(1),
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
                                      labelText: "Date Established",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
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
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Date est",
                                      textAlign: TextAlign.right,
                                      //                                style: textTheme.subtitle.copyWith(
                                      //                                  fontWeight: FontWeight.w600,
                                      //                                ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _dateStartedController.text,
                                      textAlign: TextAlign.left,
                                    ),
                                    flex: 6,
                                  )
                                ],
                              ),
                        widget.id.isEmpty || isEdit
                            ? Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text("Add Band Photo"),
                                  ),
                                  widget.id.isEmpty || isEdit
                                      ? IconButton(
                                          icon: Icon(Icons.add_a_photo),
                                          onPressed: () {
                                            if (files.length < 1)
                                              getImage();
                                            else
                                              showMessage(
                                                  "User can upload upto max 1 media files");
                                          },
                                        )
                                      : Container()
                                ],
                              )
                            : Container(),
                        files.length > 0
                            ? (widget.id.isEmpty) || (isEdit)
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

                        //                        Text(
                        //                                _dateStartedController.text,
                        //                                textAlign: TextAlign.center,
                        //                              ),

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
                        //                      widget.id.isEmpty || isEdit
                        //                          ? Container()
                        //                          : Text(
                        //                              "Website",
                        //                              textAlign: TextAlign.center,
                        //                              style: textTheme.subhead
                        //                                  .copyWith(fontWeight: FontWeight.w600),
                        //                            ),
                        //                      widget.id.isEmpty || isEdit
                        //                          ? TextField(
                        //                              enabled: widget.id.isEmpty || isEdit,
                        //                              controller: _websiteController,
                        //                              style: textTheme.subhead.copyWith(
                        //                                color: Colors.black,
                        //                              ),
                        //                              decoration: InputDecoration(
                        //                                labelText: "Website",
                        //                                labelStyle: TextStyle(
                        //                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                        //                                ),
                        //                                errorText: _errorWebsite,
                        //                                border: widget.id.isEmpty || isEdit
                        //                                    ? null
                        //                                    : InputBorder.none,
                        //                              ),
                        //                            )
                        //                          : Text(
                        //                              _websiteController.text,
                        //                              textAlign: TextAlign.center,
                        //                            ),
                        //                      Padding(
                        //                        padding: EdgeInsets.all(5),
                        //                      ),
                        //                      widget.id.isEmpty || isEdit
                        //                          ? Container()
                        //                          : Text(
                        //                              "Email Address",
                        //                              textAlign: TextAlign.center,
                        //                              style: textTheme.subhead
                        //                                  .copyWith(fontWeight: FontWeight.w600),
                        //                            ),
                        //                      widget.id.isEmpty || isEdit
                        //                          ? TextField(
                        //                              enabled: widget.id.isEmpty || isEdit,
                        //                              controller: _emailController,
                        //                              style: textTheme.subhead.copyWith(
                        //                                color: Colors.black,
                        //                              ),
                        //                              decoration: InputDecoration(
                        //                                labelText: "Email Address",
                        //                                labelStyle: TextStyle(
                        //                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                        //                                ),
                        //                                errorText: _errorEmail,
                        //                                border: widget.id.isEmpty || isEdit
                        //                                    ? null
                        //                                    : InputBorder.none,
                        //                              ),
                        //                            )
                        //                          : Text(
                        //                              _emailController.text,
                        //                              textAlign: TextAlign.center,
                        //                            ),
                        //                      Padding(
                        //                        padding: EdgeInsets.all(5),
                        //                      ),

                        Padding(
                          padding: EdgeInsets.only(
                            top: widget.id.isEmpty ? 30 : 8,
                          ),
                        ),
                        widget.id.isEmpty || isEdit
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
                                  (bandUserId != null &&
                                              bandUserId ==
                                                  presenter.serverAPI
                                                      .currentUserId) ||
                                          permission
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color:
                                                widget.appListener.accentColor,
                                          ),
                                          onPressed: () async {
                                            await widget.appListener.router
                                                .navigateTo(
                                                    context,
                                                    Screens.ADDMEMBERTOBAND
                                                            .toString() +
                                                        "//${widget.id}");
                                            showLoading();
                                            presenter.getBandDetails(widget.id);
                                          },
                                        )
                                      : Container()
                                ],
                              ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: members.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  BandMember user = members[index];
                                  String permission = "";
                                  if (user.permissions != null) {
                                    permission = user.permissions;
                                  }
                                  return InkWell(
                                    onTap: () async {
                                      await widget.appListener.router.navigateTo(
                                          context,
                                          Screens.ADDMEMBERTOBAND.toString() +
                                              "/${user.email}/${widget.id}");
                                      getData();
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(
                                        "${user.firstName} ${user.lastName} - ${user.memberRole?.join(',') ?? ''}\n$permission",
                                        style: textTheme.subhead.copyWith(
                                          color: Colors.black,
                                          fontSize: 12.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : Text(
                                "Band Contact Info",
                                textAlign: TextAlign.center,
                                style: textTheme.subhead
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                        Padding(
                          padding: EdgeInsets.all(3),
                        ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : contactInfo.isEmpty
                                ? Text(
                                    "No Member Yet",
                                    textAlign: TextAlign.center,
                                  )
                                : Column(
                                    children: contactInfo,
                                  ),
                        Padding(
                          padding: EdgeInsets.all(4),
                        ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Set-List",
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: widget.appListener.accentColor,
                                    ),
                                    onPressed: () {
                                      widget.appListener.router.navigateTo(
                                          context,
                                          Screens.SETLIST.toString() +
                                              "/${widget.id}");
                                      // showDialogConfirm();
                                    },
                                  )
                                ],
                              ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "Activites/Schedule",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ACTIVITIESLIST.toString() +
                                          "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}/");
                                },
                              ),

                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "Band Task",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ACTIVITIESLIST.toString() +
                                          "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}/${Activites.TYPE_BAND_TASK}");
                                },
                              ),

                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "Contacts",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.CONTACTLIST.toString() +
                                          "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
                                },
                              ),

                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "Equipment",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.INSTRUMENTLIST.toString() +
                                          "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
                                },
                              ),

                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "EPK",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDPLAYINGSTYLE.toString() +
                                          "/$userPlayingStyleId/${widget.id}////");

                                  // widget.appListener.router.navigateTo(
                                  //     context,
                                  //     Screens.PLAYINGSTYLELIST.toString() +
                                  //         "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
                                },
                              ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "Notes",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.NOTETODOLIST.toString() +
                                          "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
                                },
                              ),
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : FlatButton(
                                child: Text(
                                  "Stage Plot & DI Set up",
                                  textAlign: TextAlign.center,
                                  style: textTheme.subhead
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {},
                              ),

                        widget.id.isEmpty || isEdit
                            ? RaisedButton(
                                color: Color.fromRGBO(239, 181, 77, 1.0),
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
                                    String blname =
                                        _bandlegalNameController.text;
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
                                    }
                                    //                                  else if (email.isEmpty) {
                                    //                                    _errorEmail = "Cannot be empty";
                                    //                                  }
                                    //                                  else if (validateEmail(email)) {
                                    //                                    _errorEmail = "Not a Valid Email";
                                    //                                  }
                                    else {
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
                                        "",
                                        _bandCityController.text,
                                        _bandStateController.text,
                                        _bandZipController.text,
                                        files: files,
                                        id: widget.id,
                                        bandmates: bandmates,
                                      );
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
      ),
      //      floatingActionButton: widget.id.isEmpty || isEdit
      //          ? Container()
      //          : SpeedDial(
      //              marginRight: 35,
      //              animatedIcon: AnimatedIcons.menu_close,
      //              backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //              children: [
      //                SpeedDialChild(
      //                  label: "Band Activities",
      //                  child: Icon(Icons.add),
      //                  backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //                  onTap: () async {
      //                    widget.appListener.router.navigateTo(
      //                        context,
      //                        Screens.ACTIVITIESLIST.toString() +
      //                            "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
      //                  },
      //                ),
      //                SpeedDialChild(
      //                  label: "Band Contacts",
      //                  child: Icon(Icons.add),
      //                  backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //                  onTap: () async {
      //                    widget.appListener.router.navigateTo(
      //                        context,
      //                        Screens.CONTACTLIST.toString() +
      //                            "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
      //                  },
      //                ),
      //                SpeedDialChild(
      //                  label: "Band EPK",
      //                  child: Icon(Icons.add),
      //                  backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //                  onTap: () async {
      //                    widget.appListener.router.navigateTo(
      //                        context,
      //                        Screens.PLAYINGSTYLELIST.toString() +
      //                            "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
      //                  },
      //                ),
      //                SpeedDialChild(
      //                  label: "Band Task",
      //                  child: Icon(Icons.add),
      //                  backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //                  onTap: () async {
      //                    widget.appListener.router.navigateTo(
      //                        context,
      //                        Screens.ACTIVITIESLIST.toString() +
      //                            "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
      //                  },
      //                ),
      //                SpeedDialChild(
      //                  label: "Band Equipment",
      //                  child: Icon(Icons.add),
      //                  backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //                  onTap: () async {
      //                    widget.appListener.router.navigateTo(
      //                        context,
      //                        Screens.INSTRUMENTLIST.toString() +
      //                            "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
      //                  },
      //                ),
      //                SpeedDialChild(
      //                  label: "Band Notes",
      //                  child: Icon(Icons.add),
      //                  backgroundColor: Color.fromRGBO(239, 181, 77, 1.0),
      //                  onTap: () async {
      //                    widget.appListener.router.navigateTo(
      //                        context,
      //                        Screens.NOTETODOLIST.toString() +
      //                            "/${widget.id}/${permissionType == 'Leader'}/${permissionType == 'Communications'}/${permissionType == 'Setup'}/${permissionType == 'Post Entries'}");
      //                  },
      //                ),
      //              ],
      //            ),
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

  showDialogConfirm() {
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
            "Information!",
            textAlign: TextAlign.center,
          ),
          content: Text("Release date would be coming soon..."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text(
                "Okay",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(22, 102, 237, 1.0),
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
  void getBandDetails(Band band) async {
    hideLoading();
    setState(() {
      files.clear();
      files.addAll(band.files);
      bandUserId = band.userId;
      _musicStyleController.text = band.musicStyle;
      _bandlegalNameController.text = band.legalName;
      _bandNameController.text = band.name;
      _emailController.text = band.email;
      _legalStructureController.text = band.legalStructure;
      _websiteController.text = band.website;
      _bandCityController.text = band.city;
      _bandStateController.text = band.state;
      _bandZipController.text = band.zip;
      _legalUserType = (band.legalName?.isEmpty ?? false) ? 1 : 0;
      showLegalName = _legalUserType == 0 ? true : false;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(band.dateStarted);
      _dateStartedController.text = formatDate(dateTime, [M, ' ', yyyy]);
      members.clear();
      members.addAll(band.bandmates.values);
      bandmates = band.bandmates;
      primaryContactEmail = band.primaryContactEmail;
    });
  }

  @override
  void onUpdate() {
    showLoading();
    presenter.getBandDetails(widget.id);
  }

  void getData() {
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getBandDetails(widget.id);
      });
    }
  }

  @override
  void onData(List<UserPlayingStyle> acc) {
    if (acc.length > 0) {
      UserPlayingStyle userPlayingStyle = acc[0];
      userPlayingStyleId = userPlayingStyle.id;
    }
  }

  @override
  void onUserDetailsSuccess(User res) {
    setState(() {
      user = res;
    });
  }
}
