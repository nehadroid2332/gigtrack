import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddInstrumentScreen extends BaseScreen {
  final String id;

  AddInstrumentScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _AddInstrumentScreenState createState() => _AddInstrumentScreenState();
}

class _AddInstrumentScreenState
    extends BaseScreenState<AddInstrumentScreen, AddInstrumentPresenter>
    implements AddInstrumentContract {
  File _image;

  final _instrumentNameController = TextEditingController(),
      _wherePurchaseController = TextEditingController(),
      _purchaseDateController = TextEditingController(),
      _serialNumberController = TextEditingController(),
      _warrantyController = TextEditingController(),
      _warrantyEndController = TextEditingController(),
      _warrantyReferenceController = TextEditingController(),
      _warrantyCompanyController = TextEditingController(),
      _warrantyPhoneController = TextEditingController();

  String _errorInstrumentName;

  String _errorwherePurchased;

  String _errorPurchasedDate;

  String _errorSerialNumber;

  String _errorWarranty;

  String _errorWarrantyEndDate;

  String _errorWarrantyReference;

  String _errorWarrantyPhone, _errorWarrantyCompany;

  bool _instrumentInsured = false;

  var _pDateType, _eDateType;

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
                  files.clear();
                  files.add(image);
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
                  files.clear();
                  files.add(image);
                });
              },
            ),
          ],
        );
      },
    );
  }

  DateTime _date = new DateTime.now();

  int _userType = 0;

  void _handleUserTypeValueChange(int value) {
    setState(() {
      _userType = value;
    });
  }

  void _handlePDateTypeValueChange(int value) {
    setState(() {
      _pDateType = value;
    });
  }

  void _handleEDateTypeValueChange(int value) {
    setState(() {
      _eDateType = value;
    });
  }

  Band selectedBand;
  String image;
  final _bands = <Band>[];
  final files = <File>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getBands();
      if (widget.id.isNotEmpty) presenter.getInstrumentDetails(widget.id);
    });
  }

  bool isEdit = false;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(79, 73, 108, 1.0),
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

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(79, 73, 108, 1.0),
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
                "${widget.id.isEmpty ? "Add" : ""} Equipment",
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
                      borderRadius: BorderRadius.circular(15)),
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

                      widget.id.isEmpty || isEdit
                          ? Text(
                              "Type",
                              style: textTheme.headline.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(6),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _handleUserTypeValueChange(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _userType == 0
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _userType == 0
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'User',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _userType == 0
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
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
                                  onTap: () {
                                    _handleUserTypeValueChange(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _userType == 1
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _userType == 1
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Band',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _userType == 1
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
                                            : Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      (_userType == 1 && (widget.id.isEmpty || isEdit))
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButton<Band>(
                                items: _bands.map((Band value) {
                                  return new DropdownMenuItem<Band>(
                                    value: value,
                                    child: new Text(
                                      value.name,
                                      style: textTheme.caption.copyWith(
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
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Container(),
//                      Text(
//                              "Equipment Name",
//                              textAlign: TextAlign.center,
//                              style: textTheme.subhead.copyWith(
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _instrumentNameController,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Equipment Name",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
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
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Container(),
//                      Text(
//                              "Purchased Where?",
//                              textAlign: TextAlign.center,
//                              style: textTheme.subhead.copyWith(
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _wherePurchaseController,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Purchased Where?",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorwherePurchased,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                          : Text(
                              _wherePurchaseController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        "Purchased Date",
                        textAlign: widget.id.isEmpty || isEdit
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _handlePDateTypeValueChange(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _pDateType == 0
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _pDateType == 0
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Date Known',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _pDateType == 0
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
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
                                  onTap: () {
                                    _handlePDateTypeValueChange(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _pDateType == 1
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _pDateType == 1
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Date Unknown',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _pDateType == 1
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
                                            : Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit
                          ? _pDateType != null
                              ? GestureDetector(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      enabled: widget.id.isEmpty || isEdit,
                                      controller: _purchaseDateController,
                                      decoration: InputDecoration(
                                        labelText:
                                            "${_pDateType == 1 ? 'Approximate' : ''} Date",
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              202, 208, 215, 1.0),
                                        ),
                                        errorText: _errorPurchasedDate,
                                        border: widget.id.isEmpty || isEdit
                                            ? null
                                            : InputBorder.none,
                                      ),
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (widget.id.isEmpty || isEdit) {
                                      final DateTime picked =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1959),
                                        initialDate: _date,
                                        lastDate: DateTime(2022),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          //_date = picked;
                                          _purchaseDateController.text =
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
                              : Container()
                          : Text(
                              _purchaseDateController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Serial Number",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _serialNumberController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: "Serial Number",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
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
                          : Text(
                              _serialNumberController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Warranty",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _warrantyController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: "Warranty",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _errorWarranty,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              _warrantyController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        "Warranty EndDate",
                        textAlign: widget.id.isEmpty || isEdit
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _handleEDateTypeValueChange(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _eDateType == 0
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _eDateType == 0
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Yet to Expire',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _eDateType == 0
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
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
                                  onTap: () {
                                    _handleEDateTypeValueChange(1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _eDateType == 1
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _eDateType == 1
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Expired',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _eDateType == 1
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
                                            : Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit
                          ? _eDateType != null && _eDateType == 0
                              ? GestureDetector(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      enabled: widget.id.isEmpty || isEdit,
                                      controller: _warrantyEndController,
                                      decoration: InputDecoration(
                                        labelText: "Date",
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              202, 208, 215, 1.0),
                                        ),
                                        errorText: _errorWarrantyEndDate,
                                        border: widget.id.isEmpty || isEdit
                                            ? null
                                            : InputBorder.none,
                                      ),
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (widget.id.isEmpty || isEdit) {
                                      final DateTime picked =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: _date,
                                        initialDate: _date,
                                        lastDate: DateTime(2022),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          //_date = picked;
                                          _warrantyEndController.text =
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
                              : Container()
                          : Text(
                              _warrantyEndController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(_eDateType == 0 ? 5 : 0),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Warranty Reference",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? _eDateType == 0
                              ? TextField(
                                  enabled: widget.id.isEmpty || isEdit,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: _warrantyReferenceController,
                                  decoration: InputDecoration(
                                    labelText: "Warranty Reference",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    errorText: _errorWarrantyReference,
                                    border: widget.id.isEmpty || isEdit
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black,
                                  ),
                                )
                              : Container()
                          : Text(
                              _warrantyReferenceController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(_eDateType == 0 ? 5 : 0),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Text(
                              "Warranty Phone",
                              textAlign: TextAlign.center,
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? _eDateType == 0
                              ? TextField(
                                  controller: _warrantyPhoneController,
                                  enabled: widget.id.isEmpty || isEdit,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: "Warranty Phone",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    errorText: _errorWarrantyPhone,
                                    border: widget.id.isEmpty || isEdit
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black,
                                  ),
                                  onEditingComplete: () {
                                    setState(() {});
                                  },
                                )
                              : Container()
                          : Text(
                              _warrantyPhoneController.text,
                              textAlign: TextAlign.center,
                            ),

                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _instrumentInsured = value;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  value: _instrumentInsured,
                                ),
                                Text(
                                  "Is Instrument Insured?",
                                  style: textTheme.caption.copyWith(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Upload Invoice"),
                                ),
                                widget.id.isEmpty || isEdit
                                    ? IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () {
                                          if (files.length < 1)
                                            getImage();
                                          else
                                            showMessage(
                                                "User can upload upto max 2 media files");
                                        },
                                      )
                                    : Container()
                              ],
                            )
                          : Container(),
                      (image != null && image.isNotEmpty) && !isEdit
                          ? Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 80,
                              width: 150,
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ),
                            )
                          : files.length > 0
                              ? SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                    itemCount: files.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      File file = files[index];
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 80,
                                        width: 150,
                                        child: Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? RaisedButton(
                              color: Color.fromRGBO(79, 73, 108, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              textColor: Colors.white,
                              onPressed: () {
                                String instrumentName =
                                    _instrumentNameController.text;
                                String wherePurchased =
                                    _wherePurchaseController.text;
                                String purchasedDate =
                                    _purchaseDateController.text;
                                String sno = _serialNumberController.text;
                                String warranty = _warrantyController.text;
                                String wendDate = _warrantyEndController.text;
                                String wRef = _warrantyReferenceController.text;
                                String wPh = _warrantyPhoneController.text;
                                String com = _warrantyCompanyController.text;
                                setState(() {
                                  if (instrumentName.isEmpty) {
                                    _errorInstrumentName = "Cannot be Empty";
                                  } else if (wherePurchased.isEmpty) {
                                    _errorwherePurchased = "Cannot be Empty";
                                  } else if (purchasedDate.isEmpty) {
                                    _errorPurchasedDate = "Cannot be Empty";
                                  } else if (sno.isEmpty) {
                                    _errorSerialNumber = "Cannot be Empty";
                                  } else if (warranty.isEmpty) {
                                    _errorWarranty = "Cannot be Empty";
                                  }
                                  //  else if (wendDate.isEmpty) {
                                  //   _errorWarrantyEndDate = "Cannot be Empty";
                                  // } else if (wRef.isEmpty) {
                                  //   _errorWarrantyReference = "Cannot be Empty";
                                  // } else if (wPh.isEmpty) {
                                  //   _errorWarrantyPhone = "Cannot be Empty";
                                  // } else if (com.isEmpty) {
                                  //   _errorWarrantyCompany = "Cannot be Empty";
                                  // }
                                  else {
                                    Instrument instrument = Instrument(
                                      band_id: selectedBand?.id ?? "0",
                                      is_insured:
                                          _instrumentInsured ? "1" : "0",
                                      name: instrumentName,
                                      purchased_date: purchasedDate,
                                      purchased_from: wherePurchased,
                                      serial_number: sno,
                                      user_id: presenter.serverAPI.userId,
                                      warranty: warranty,
                                      warranty_end_date: wendDate,
                                      warranty_phone: wPh,
                                      warranty_reference: wRef,
                                      id: id,
                                    );
                                    instrument.files = files;
                                    showLoading();
                                    presenter.addInstrument(instrument);
                                  }
                                });
                              },
                              child: Text("Submit"),
                            )
                          : Container()
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
  AddInstrumentPresenter get presenter => AddInstrumentPresenter(this);

  @override
  void addInstrumentSuccess(res) {
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
    showMessage(res.message);
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

  var id;
  @override
  void getInstrumentDetails(Instrument instrument) {
    hideLoading();
    setState(() {
      id = instrument.id;
      _instrumentNameController.text = instrument.name;
      _instrumentInsured = instrument.is_insured == "1";
      DateTime purchasedDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(instrument.purchased_date));
      _purchaseDateController.text =
          "${formatDate(purchasedDate, [yyyy, '-', mm, '-', dd])}";
      _serialNumberController.text = instrument.serial_number;
      _warrantyController.text = instrument.warranty;
      DateTime warrantyDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(instrument.warranty_end_date));
      _warrantyEndController.text =
          "${formatDate(warrantyDate, [yyyy, '-', mm, '-', dd])}";
      _warrantyPhoneController.text = instrument.warranty_phone;
      _warrantyReferenceController.text = instrument.warranty_reference;
      _wherePurchaseController.text = instrument.purchased_from;
      image = instrument.image;
    });
  }
}
