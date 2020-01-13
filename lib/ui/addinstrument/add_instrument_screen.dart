import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user_instrument.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';

class AddInstrumentScreen extends BaseScreen {
  final String id;
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  AddInstrumentScreen(
    AppListener appListener, {
    this.id,
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "");

  @override
  _AddInstrumentScreenState createState() => _AddInstrumentScreenState();
}

class _AddInstrumentScreenState
    extends BaseScreenState<AddInstrumentScreen, AddInstrumentPresenter>
    implements AddInstrumentContract {
  File _image;

  bool _ispurchaseDate = false;
  bool _iswarrantyInfo = false;
  bool _iswarrantydate = false;
  bool _isnickNameEuip = false;
  bool _isinsuranceInfo = false;

  bool _iswarrantyAvailable = false;
  bool _isinsuranceAvailable = false;

  final _instrumentNameController = TextEditingController(),
      _wherePurchaseController = TextEditingController(),
      _purchaseDateController = TextEditingController(),
      _serialNumberController = TextEditingController(),
      _warrantyController = TextEditingController(),
      _warrantyEndController = TextEditingController(),
      _warrantyReferenceController = TextEditingController(),
      _warrantyCompanyController = TextEditingController(),
      _costController = TextEditingController(),
      _warrantyPhoneController = TextEditingController(),
      _instrumentNickNameController = TextEditingController(),
      _insuredController = TextEditingController(),
      _noteContactController = TextEditingController(),
      _policyController = TextEditingController();

  String _errorInstrumentName;

  String _errorCost;

  var _cost;

  String _errorwherePurchased;

  String _errorPurchasedDate;

  String _errorSerialNumber;

  String _errorWarranty;

  String _errorWarrantyEndDate;

  String _errorWarrantyReference;

  String _errorWarrantyPhone, _errorWarrantyCompany;

  bool _instrumentInsured = false;

  var _pDateType = 1, _eDateType;

  DateTime purchasedDate;

  DateTime warrantyEndDate;

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
                var image = await ImagePicker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);
                _cropImage(image);
              },
            ),
          ],
        );
      },
    );
  }

  DateTime _date = new DateTime.now();

  int _userType = 0;

  // void _handleUserTypeValueChange(int value) {
  //   setState(() {
  //     _userType = value;
  //   });
  // }

  // void _handlePDateTypeValueChange(int value) {
  //   setState(() {
  //     _pDateType = value;
  //   });
  // }

  // void _handleEDateTypeValueChange(int value) {
  //   setState(() {
  //     _eDateType = value;
  //   });
  // }

  Band selectedBand;
  List<Band> _bands = <Band>[];
  List files = <dynamic>[];
  Stream<List<Band>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getBands();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.id.isNotEmpty) {
        showLoading();
        presenter.getInstrumentDetails(widget.id);
      }
    });
  }

  bool isEdit = false;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
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
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          _submitInstrument();
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
        backgroundColor: Colors.deepOrangeAccent,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: widget.id.isEmpty
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2,
            child: Text(
              "${widget.id.isEmpty ? "Add" : isEdit ? "Edit" : ""} Equipment",
              textAlign: TextAlign.center,
              style: textTheme.headline.copyWith(
                color: Colors.white,
              ),
            ),
          ),
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
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (id == null || id.isEmpty) {
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
  SubInstrumentNotes subContact;
  List<SubInstrumentNotes> subContacts = [];

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 4.5),
          child: Container(
            color: Colors.deepOrangeAccent,
            height: height / 4.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: subContact != null
                      ? ListView(
                          padding: EdgeInsets.all(10),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            TextField(
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: "Add Note",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                  fontSize: 18,
                                ),
                              ),
                              controller: _noteContactController,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  subContact.title =
                                      _noteContactController.text;
                                  subContact.id = randomString(12);
                                  subContact.createdDate =
                                      DateTime.now().millisecondsSinceEpoch;
                                  subContacts.add(subContact);
                                  presenter.addSubInstrumentNote(
                                      subContacts, widget.id);
                                  subContact = null;
                                });
                              },
                              color: Color.fromRGBO(3, 218, 157, 1.0),
                              child: Text(
                                "Submit",
                                style: textTheme.headline.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textColor: Colors.white,
                            )
                          ],
                        )
                      : Column(children: <Widget>[
                    widget.id.isEmpty || isEdit?Expanded(
                          flex: 3,
                          child:
                        widget.id.isEmpty || isEdit
                            ? Container()
                            : files != null && files.length > 0
                            ? Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    File(files[0]).path,
                                  ),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0)),
                            ),
                            margin: EdgeInsets.only(
                                left: 10, right: 10,top: 10),
                            height:
                            MediaQuery.of(context).size.height /
                                4.2,
                            width: MediaQuery.of(context).size.width,
                            child: null)
                            : Container(),):Container(),
                        
                        Expanded(
                          flex:8,
                          child:  ListView(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 10, bottom: 15),
                          children: <Widget>[
                            (_userType == 1 && (widget.id.isEmpty || isEdit))
                                ? Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 20),
                              child: StreamBuilder(
                                stream: list,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    _bands = snapshot.data;
                                  } else {
                                    _bands = <Band>[];
                                  }
                                  return DropdownButton<Band>(
                                    items: _bands.map((Band value) {
                                      return new DropdownMenuItem<Band>(
                                        value: value,
                                        child: new Text(
                                          value.name,
                                          style:
                                          textTheme.caption.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    onChanged: (b) {
                                      setState(() {
                                        selectedBand = b;
                                      });
                                    },
                                    value: selectedBand,
                                  );
                                },
                              ),
                            )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 0, bottom: 5),
                            ),
                           
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 0),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : _instrumentNickNameController.text.isNotEmpty
                                ? Text(
                              _instrumentNickNameController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic),
                            )
                                : Container(),
                            Padding(
                              padding:
                              _instrumentNickNameController.text.isNotEmpty
                                  ? EdgeInsets.only(
                                  left: 8, right: 8, top: 3, bottom: 3)
                                  : EdgeInsets.all(0),
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _instrumentNameController,
                              textCapitalization:
                              TextCapitalization.words,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Equipment Name",
                                labelStyle: TextStyle(
                                  color:
                                  Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorInstrumentName,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                                : Text(
                              _instrumentNameController.text,
                              textAlign: TextAlign.center,
                              style: textTheme.subtitle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: widget.id.isEmpty
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(0),
                            ),
                            ShowUp(
                              child: !_isnickNameEuip
                                  ? new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isnickNameEuip = true;
                                  });
                                },
                                child: widget.id.isEmpty
                                    ? Text(
                                  "Click to add special name",
                                  style: textTheme.display1
                                      .copyWith(
                                      color: widget.appListener
                                          .primaryColorDark,
                                      fontSize: 14),
                                )
                                    : Container(),
                              )
                                  : Container(),
                              delay: 1000,
                            ),
                            _isnickNameEuip || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _instrumentNickNameController,
                              textCapitalization:
                              TextCapitalization.words,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty || isEdit
                                    ? "Equipment Nick Name"
                                    : "",
                                labelStyle: TextStyle(
                                  color:
                                  Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorInstrumentName,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                                : Container(),
                            Padding(
                              padding:
                              _instrumentNickNameController.text.isEmpty
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(5),
                            ),
                            widget.id.isNotEmpty && !isEdit
                                ? Column(
                              children: <Widget>[
                                Text(
                                  "Purchased",
                                  textAlign: TextAlign.right,
                                  style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                Container(
                                  height: 1,
                                  width: 100,
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _purchaseDateController.text,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      " - ${_costController.text}",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                )
                              ],
                            )
                                : Container(),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _wherePurchaseController,
                              textCapitalization:
                              TextCapitalization.words,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Purchased Where?",
                                labelStyle: TextStyle(
                                  color:
                                  Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorwherePurchased,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                                : _wherePurchaseController.text.isEmpty
                                ? Container()
                                : Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(1),
                                ),
                                Text(
                                  _wherePurchaseController.text,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Padding(
                              padding: _wherePurchaseController.text.isEmpty
                                  ? EdgeInsets.all(3)
                                  : EdgeInsets.all(2),
                            ),
                            Padding(
                              padding: widget.id.isEmpty
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(0),
                            ),
                            widget.id.isEmpty || isEdit
                                ? ShowUp(
                              child: !_ispurchaseDate
                                  ? new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _ispurchaseDate = true;
                                  });
                                },
                                child: widget.id.isEmpty
                                    ? Text(
                                  "Click here to add purchase date",
                                  style: textTheme.display1
                                      .copyWith(
                                      color: widget
                                          .appListener
                                          .primaryColorDark,
                                      fontSize: 16),
                                )
                                    : Container(),
                              )
                                  : Container(),
                              delay: 1000,
                            )
                                : Container(),
                            _ispurchaseDate || widget.id.isNotEmpty
                                ? Container(
                              child: Column(
                                crossAxisAlignment:
                                widget.id.isEmpty || isEdit
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.center,
                                children: <Widget>[
                                  widget.id.isEmpty || isEdit
                                      ? Text(
                                    "Purchased Date",
                                    textAlign:
                                    widget.id.isEmpty || isEdit
                                        ? TextAlign.left
                                        : TextAlign.center,
                                    style:
                                    textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : Container(),
                                  Padding(
                                    padding: _purchaseDateController
                                        .text.isEmpty
                                        ? EdgeInsets.all(0)
                                        : EdgeInsets.all(0),
                                  ),
                                  widget.id.isEmpty || isEdit
                                      ? GestureDetector(
                                    child: AbsorbPointer(
                                      child: TextField(
                                        enabled:
                                        widget.id.isEmpty ||
                                            isEdit,
                                        controller:
                                        _purchaseDateController,
                                        decoration: InputDecoration(
                                          labelText: "Date",
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                          ),
                                          errorText:
                                          _errorPurchasedDate,
                                          border: widget
                                              .id.isEmpty ||
                                              isEdit
                                              ? null
                                              : InputBorder.none,
                                        ),
                                        style: textTheme.subhead
                                            .copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (widget.id.isEmpty ||
                                          isEdit) {
                                        final DateTime picked =
                                        await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1959),
                                          initialDate: _date,
                                          lastDate: DateTime(2022),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            purchasedDate = picked;
                                            //_date = picked;
                                            _purchaseDateController
                                                .text =
                                            "${formatDate(picked, [
                                              mm,
                                              '-',
                                              dd,
                                              '-',
                                              yy
                                            ])}";
                                          });
                                        }
                                      }
                                    },
                                  )
                                      : widget.id.isEmpty || isEdit
                                      ? Text(
                                    _purchaseDateController
                                        .text,
                                    textAlign: TextAlign.center,
                                    style:
                                    TextStyle(fontSize: 17),
                                  )
                                      : _purchaseDateController
                                      .text.isEmpty
                                      ? Container()
                                      : Row(
                                    children: <Widget>[
//                                                    Expanded(
//                                                      flex: 5,
//                                                      child: Text(
//                                                        "Purch date",
//                                                        textAlign:
//                                                            TextAlign.right,
//                                                        style: textTheme
//                                                            .subtitle
//                                                            .copyWith(
//                                                          fontWeight:
//                                                              FontWeight.w600,
//                                                        ),
//                                                      ),
//                                                    ),
//                                                    Expanded(
//                                                      child: Text(
//                                                        " - ",
//                                                        textAlign:
//                                                            TextAlign.center,
//                                                        style: TextStyle(
//                                                            fontSize: 17),
//                                                      ),
//                                                      flex: 1,
//                                                    ),
//                                                    Expanded(
//                                                      flex: 5,
//                                                      child: Text(
//                                                        _purchaseDateController
//                                                            .text,
//                                                        textAlign:
//                                                            TextAlign.left,
//                                                      ),
//                                                    ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                                : Container(),
    
                            Padding(
                              padding: _purchaseDateController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(0),
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _costController,
                              textCapitalization:
                              TextCapitalization.words,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Cost",
                                prefixText: '\$',
                                labelStyle: TextStyle(
                                  color:
                                  Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorCost,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                                : _costController.text.isEmpty
                                ? Container()
                                : Column(
                              children: <Widget>[
//                                    Text(
//                                      "Cost",
//                                      textAlign: TextAlign.right,
//                                      style: textTheme.subtitle.copyWith(
//                                        fontWeight: FontWeight.w600,
//                                      ),
//                                    ),
//                                    Container(
//                                      height: 1,
//                                      width: 100,
//                                      color: Colors.black,
//                                    ),
//                                    Text(
//                                      "\$" + _cost.toString(),
//                                      textAlign: TextAlign.left,
//                                    )
                              ],
                            ),
                            Padding(
                              padding: _costController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(0),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : Container(),
//                      Text(
//                              "Serial Number",
//                              textAlign: TextAlign.center,
//                              style: textTheme.subhead.copyWith(
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _serialNumberController,
                              textCapitalization:
                              TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: "Serial Number",
                                labelStyle: TextStyle(
                                  color:
                                  Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorSerialNumber,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                                : _serialNumberController.text.isEmpty
                                ? Container()
                                : Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "SN# ",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 16),
                                ),
//                                    Container(
//                                      height: 1,
//                                      width: 100,
//                                      color: Colors.black,
//                                    ),
                                Text(
                                  "  ${_serialNumberController.text}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Padding(
                              padding: _serialNumberController.text.isEmpty
                                  ? EdgeInsets.all(3)
                                  : EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : Container(),
                            Padding(
                              padding: widget.id.isEmpty
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(0),
                            ),
                            ShowUp(
                              child: !_iswarrantyInfo
                                  ? new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _iswarrantyInfo = true;
                                    _iswarrantyAvailable = true;
                                  });
                                },
                                child: widget.id.isEmpty
                                    ? Text(
                                  "Click here to add warranty info",
                                  style: textTheme.display1
                                      .copyWith(
                                      color: widget.appListener
                                          .primaryColorDark,
                                      fontSize: 16),
                                )
                                    : Container(),
                              )
                                  : Container(),
                              delay: 1000,
                            ),
                            _iswarrantyInfo || widget.id.isNotEmpty
                                ? Container(
                              child: Column(
                                children: <Widget>[
                                  widget.id.isEmpty || isEdit
                                      ? TextField(
                                    enabled:
                                    widget.id.isEmpty || isEdit,
                                    controller: _warrantyController,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    decoration: InputDecoration(
                                      labelText: "Warranty",
                                      labelStyle: TextStyle(
                                        color: Color.fromRGBO(
                                            202, 208, 215, 1.0),
                                      ),
                                      errorText: _errorWarranty,
                                      border: widget.id.isEmpty ||
                                          isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                    style:
                                    textTheme.subhead.copyWith(
                                      color: Colors.black,
                                    ),
                                  )
                                      : _warrantyController.text.isEmpty
                                      ? Container()
                                      : Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                            top: 2),
                                      ),
                                      Center(
                                        child: Text(
                                          "Warranty",
                                          textAlign:
                                          TextAlign.right,
                                          style: textTheme
                                              .subtitle
                                              .copyWith(
                                              fontWeight:
                                              FontWeight
                                                  .w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: 100,
                                        color: Colors.black,
                                      ),
                                      Center(
                                        child: Text(
                                          _warrantyController
                                              .text,
                                          textAlign:
                                          TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    _warrantyController.text.isEmpty
                                        ? EdgeInsets.all(0)
                                        : EdgeInsets.all(0),
                                  ),
                                  Padding(
                                    padding: widget.id.isEmpty
                                        ? EdgeInsets.all(5)
                                        : EdgeInsets.all(0),
                                  ),
                                  ShowUp(
                                    child: !_iswarrantydate
                                        ? new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _iswarrantydate = true;
                                        });
                                      },
                                      child: widget.id.isEmpty
                                          ? Text(
                                        "Click here to add warranty end date",
                                        style: textTheme
                                            .display1
                                            .copyWith(
                                            color: widget
                                                .appListener
                                                .primaryColorDark,
                                            fontSize: 16),
                                      )
                                          : Container(),
                                    )
                                        : Container(),
                                    delay: 1000,
                                  ),
                                  _iswarrantydate || widget.id.isNotEmpty
                                      ? Container(
                                    child: Column(
                                      crossAxisAlignment: widget
                                          .id.isEmpty ||
                                          isEdit
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        widget.id.isEmpty || isEdit
                                            ? GestureDetector(
                                          child:
                                          AbsorbPointer(
                                            child: TextField(
                                              enabled: widget
                                                  .id
                                                  .isEmpty ||
                                                  isEdit,
                                              controller:
                                              _warrantyEndController,
                                              decoration:
                                              InputDecoration(
                                                labelText:
                                                "Warranty End Date",
                                                labelStyle:
                                                TextStyle(
                                                  color: Color
                                                      .fromRGBO(
                                                      202,
                                                      208,
                                                      215,
                                                      1.0),
                                                ),
                                                errorText:
                                                _errorWarrantyEndDate,
                                                border: widget
                                                    .id
                                                    .isEmpty ||
                                                    isEdit
                                                    ? null
                                                    : InputBorder
                                                    .none,
                                              ),
                                              style: textTheme
                                                  .subhead
                                                  .copyWith(
                                                color: Colors
                                                    .black,
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (widget.id
                                                .isEmpty ||
                                                isEdit) {
                                              final DateTime
                                              picked =
                                              await showDatePicker(
                                                context:
                                                context,
                                                firstDate:
                                                _date,
                                                initialDate:
                                                _date,
                                                lastDate:
                                                DateTime(
                                                    2022),
                                              );
                                              if (picked !=
                                                  null) {
                                                setState(() {
                                                  //_date = picked;
                                                  warrantyEndDate =
                                                      picked;
                                                  _warrantyEndController
                                                      .text =
                                                  "${formatDate(picked, [
                                                    mm,
                                                    '-',
                                                    dd,
                                                    '-',
                                                    yy
                                                  ])}";
                                                });
                                              }
                                            }
                                          },
                                        )
                                            : _warrantyEndController
                                            .text.isEmpty
                                            ? Container()
                                            : Row(
                                          children: <
                                              Widget>[
                                            Expanded(
                                              flex: 7,
                                              child: Text(
                                                  "Expires",
                                                  textAlign:
                                                  TextAlign
                                                      .right,
                                                  style: TextStyle(
                                                      fontSize:
                                                      15)),
                                            ),
                                            Expanded(
                                              child: Text(
                                                " - ",
                                                textAlign:
                                                TextAlign
                                                    .center,
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              flex: 7,
                                              child: Text(
                                                _warrantyEndController
                                                    .text,
                                                textAlign:
                                                TextAlign
                                                    .left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                      : Container(),
                                  Padding(
                                    padding: _warrantyEndController
                                        .text.isEmpty
                                        ? EdgeInsets.all(0)
                                        : EdgeInsets.all(
                                        _eDateType == 0 ? 5 : 5),
                                  ),
                                ],
                              ),
                            )
                                : Container(),
    
                            Padding(
                              padding: _warrantyEndController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(0),
                            ),
                            Padding(
                              padding: widget.id.isEmpty
                                  ? EdgeInsets.all(8)
                                  : EdgeInsets.all(0),
                            ),
                            ShowUp(
                              child: !_isinsuranceInfo
                                  ? new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isinsuranceInfo = true;
                                    _isinsuranceAvailable = true;
                                  });
                                },
                                child: widget.id.isEmpty
                                    ? Text(
                                  "Click to add Insurance info",
                                  style: textTheme.display1
                                      .copyWith(
                                      color: widget.appListener
                                          .primaryColorDark,
                                      fontSize: 16),
                                )
                                    : Container(),
                              )
                                  : Container(),
                              delay: 1000,
                            ),
                            _isinsuranceInfo || widget.id.isNotEmpty
                                ? widget.id.isEmpty || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _insuredController,
                              textCapitalization:
                              TextCapitalization.words,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Insured with",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(
                                      202, 208, 215, 1.0),
                                ),
                                errorText: _errorCost,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                                : _insuredController.text.isNotEmpty
                                ? Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Insurance",
                                    textAlign: TextAlign.right,
                                    style: textTheme.subtitle
                                        .copyWith(
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: 100,
                                  color: Colors.black,
                                ),
                                Center(
                                  child: Text(
                                    _insuredController.text,
                                    textAlign: TextAlign.left,
                                    style:
                                    TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                                : Container()
                                : Container(),
                            Padding(
                              padding: _insuredController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(1),
                            ),
                            _isinsuranceInfo || widget.id.isNotEmpty
                                ? widget.id.isEmpty || isEdit
                                ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _policyController,
                              textCapitalization:
                              TextCapitalization.words,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Policy no.",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(
                                      202, 208, 215, 1.0),
                                ),
                                errorText: _errorCost,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                                : _policyController.text.isNotEmpty
                                ? Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Policy #  ",
                                    textAlign: TextAlign.right,
                                    style: textTheme.subtitle
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "  ${_policyController.text}",
                                    textAlign: TextAlign.left,
                                    style:
                                    TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                                : Container()
                                : Container(),
                            widget.id.isEmpty || isEdit
                                ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Take Invoice/Equip. photo",
                                    style: TextStyle(fontSize: 16),
                                  ),
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
                                ? widget.id.isEmpty || isEdit
                                ? SizedBox(
                              height: 90,
                              child: ListView.builder(
                                itemCount: files.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context,
                                    int index) {
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
                                          fit: BoxFit
                                              .cover,
                                        )
                                            : Image.file(
                                          file,
                                          fit: BoxFit
                                              .cover,
                                        ),
                                        Positioned(
                                          right: 14,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                files =
                                                new List();
                                              });
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors
                                                    .white,
                                              ),
                                              color:
                                              Colors.black,
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
                                                files =
                                                new List();
                                              });
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors
                                                    .white,
                                              ),
                                              color:
                                              Colors.black,
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
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            widget.id.isNotEmpty && !isEdit
                                ? ShowUp(
                              child: new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    subContact = SubInstrumentNotes();
                                  });
                                },
                                child: Text(
                                  "Click here to add equipment notes",
                                  textAlign: TextAlign.center,
                                  style: textTheme.display1.copyWith(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                              delay: 1000,
                            )
                                : Container(),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/5,right: MediaQuery.of(context).size.width/5,top: 3,bottom: 14),
                            ),
                            ListView.builder(
                              itemCount: subContacts.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                SubInstrumentNotes notesTodo =
                                subContacts[index];
                                DateTime dateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    notesTodo.createdDate);
                                return ListTile(
                                  title: Text(notesTodo.title),
                                  leading: CircleAvatar(
                                      backgroundColor:
                                      Color.fromRGBO(3, 218, 157, 1.0),
                                      radius: 35,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${formatDate(dateTime, [dd])}",
                                                textAlign: TextAlign.center,
                                                style:
                                                textTheme.headline.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                "${formatDate(dateTime, [M])}",
                                                textAlign: TextAlign.center,
                                                style:
                                                textTheme.caption.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${formatDate(dateTime, [
                                                "/",
                                                yy
                                              ])}",
                                              textAlign: TextAlign.center,
                                              style: textTheme.caption.copyWith(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? RaisedButton(
                              color: Colors.deepOrangeAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18)),
                              textColor: Colors.white,
                              onPressed: () {
                                _submitInstrument();
                              },
                              child: Text("Submit"),
                            )
                                : Container()
                          ],
                        ),)
                   
                  ],)
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  AddInstrumentPresenter get presenter => AddInstrumentPresenter(this);

  @override
  void addInstrumentSuccess() {
    if (!mounted) return;
    hideLoading();
    _instrumentNameController.clear();
    _wherePurchaseController.clear();
    _purchaseDateController.clear();
    _serialNumberController.clear();
    _warrantyController.clear();
    _warrantyEndController.clear();
    _warrantyReferenceController.clear();
    _warrantyPhoneController.clear();
    _instrumentNickNameController.clear();
    _policyController.clear();
    showMessage("Created sucessfully");
    Timer timer = new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  void onBandList(List<Band> bands) {
    if (!mounted) return;
    hideLoading();
    setState(() {
      _bands.clear();
      _bands.addAll(bands);
    });
  }

  String id;
  @override
  void getInstrumentDetails(UserInstrument instrument) {
    hideLoading();
    setState(() {
      id = instrument.id;
      subContacts = instrument.subNotes;
      _instrumentNameController.text = instrument.name;
      _instrumentInsured = instrument.is_insured;
      if (instrument.purchased_date == 0) {
        _purchaseDateController.text = null;
      } else {
        DateTime purchasedDate1 =
            DateTime.fromMillisecondsSinceEpoch((instrument.purchased_date));
        purchasedDate = purchasedDate1;
        _purchaseDateController.text =
            "${formatDate(purchasedDate1, [mm, '/', dd, '/', yy])}";
      }
      _serialNumberController.text = instrument.serial_number;
      _warrantyController.text = instrument.warranty;
      if (instrument.warranty_end_date == 0) {
        _warrantyEndController.text = null;
      } else {
        DateTime warrantyDate =
            DateTime.fromMillisecondsSinceEpoch((instrument.warranty_end_date));
        warrantyEndDate = warrantyDate;
        _warrantyEndController.text =
            "${formatDate(warrantyDate, [mm, '/', dd, '/', yy])}";
      }
      _warrantyPhoneController.text = instrument.warranty_phone;
      _warrantyReferenceController.text = instrument.warranty_reference;
      _wherePurchaseController.text = instrument.purchased_from;
      var moneyformatter =
          instrument.cost.isNotEmpty ? double.parse(instrument.cost) : 0.0;
      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
          amount: moneyformatter,
          settings: MoneyFormatterSettings(
            symbol: 'US',
            thousandSeparator: ',',
            decimalSeparator: '.',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2,
          ));
      _costController.text = instrument.cost;
      _cost = fmf.output.nonSymbol.toString();
      if (instrument.uploadedFiles != null) files = instrument.uploadedFiles;
      _instrumentNickNameController.text = instrument.nickName;
      _insuredController.text = instrument.insuranceno;
      _policyController.text = instrument.policyno;
      _isinsuranceAvailable = instrument.isInsurance;
      _iswarrantyAvailable = instrument.isWarranty;
    });
  }

  @override
  void onUpdate() {
    showMessage("Updated Successfully");
  }

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
              color: Colors.white,
              onPressed: () {
                if (id == null || id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  presenter.instrumentDelete(id);
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      Screens.INSTRUMENTLIST.toString() + "/////"));
                  //Navigator.of(context).pop();
                }
              },
            ),
            new RaisedButton(
              textColor: Colors.white,
              color: Color.fromRGBO(191, 53, 42, 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _submitInstrument() {
    String instrumentName = _instrumentNameController.text;
    String wherePurchased = _wherePurchaseController.text;
    String purchasedDate = _purchaseDateController.text;
    String sno = _serialNumberController.text;
    String warranty = _warrantyController.text;
    String wendDate = _warrantyEndController.text;
    String wRef = _warrantyReferenceController.text;
    String wPh = _warrantyPhoneController.text;
    String com = _warrantyCompanyController.text;
    String cost = _costController.text;
    String nickName = _instrumentNickNameController.text;
    String insuranceno = _insuredController.text;
    String policyno = _policyController.text;
    bool warrantyInfo = _iswarrantyAvailable;
    setState(() {
      if (instrumentName.isEmpty) {
        _errorInstrumentName = "Cannot be Empty";
      } else {
        UserInstrument instrument = UserInstrument(
            band_id: selectedBand?.id ?? "0",
            is_insured: _instrumentInsured,
            bandId: widget.bandId,
            name: instrumentName,
            purchased_date: this.purchasedDate != null
                ? this.purchasedDate.millisecondsSinceEpoch
                : 0,
            purchased_from: wherePurchased,
            serial_number: sno,
            user_id: presenter.serverAPI.userId,
            warranty: warranty,
            warranty_end_date: this.warrantyEndDate != null
                ? this.warrantyEndDate.millisecondsSinceEpoch
                : 0,
            warranty_phone: wPh,
            warranty_reference: wRef,
            nickName: nickName,
            id: id,
            cost: cost,
            insuranceno: insuranceno,
            isWarranty: warrantyInfo,
            uploadedFiles: files,
            policyno: policyno);

        showLoading();
        presenter.addInstrument(instrument);
      }
    });
  }
}
