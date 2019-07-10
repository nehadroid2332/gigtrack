import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_presenter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

class AddInstrumentScreen extends BaseScreen {
  final String id;
  AddInstrumentScreen(AppListener appListener, {this.id}) : super(appListener);

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
      _warrantyPhoneController = TextEditingController();

  String _errorInstrumentName;

  String _errorwherePurchased;

  String _errorPurchasedDate;

  String _errorSerialNumber;

  String _errorWarranty;

  String _errorWarrantyEndDate;

  String _errorWarrantyReference;

  String _errorWarrantyPhone;

  bool _instrumentInsured = false;

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

  DateTime _date = new DateTime.now();

  int _userType = 0;
  void _handleUserTypeValueChange(int value) {
    setState(() {
      _userType = value;
    });
  }

  Band selectedBand;
  final _bands = <Band>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getBands();
      if (widget.id.isNotEmpty) presenter.getInstrumentDetails(widget.id);
    });
  }

  @override
  Widget buildBody() {
    return Container(
        color: Color.fromRGBO(240, 243, 244, 0.5),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
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
                    "${widget.id.isEmpty ? "Add " : ""}Instrument",
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
                    Padding(
                      padding: EdgeInsets.all(20),
                    ),
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

                    widget.id.isEmpty
                        ? Text(
                            "Type",
                            style: textTheme.caption.copyWith(
                              color: Colors.white,
                            ),
                          )
                        : Container(),
                    widget.id.isEmpty
                        ? Row(
                            children: <Widget>[
                              new Radio(
                                value: 0,
                                groupValue: _userType,
                                onChanged: _handleUserTypeValueChange,
                              ),
                              new Text(
                                'User',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 1,
                                groupValue: _userType,
                                onChanged: _handleUserTypeValueChange,
                              ),
                              new Text(
                                'Band',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (_userType == 1 && widget.id.isEmpty)
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButton<Band>(
                              items: _bands.map((Band value) {
                                return new DropdownMenuItem<Band>(
                                  value: value,
                                  child: new Text(
                                    value.name,
                                    style: textTheme.caption.copyWith(
                                      color: Colors.white,
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
                    TextField(
                      enabled: widget.id.isEmpty,
                      controller: _instrumentNameController,
                      decoration: InputDecoration(
                          labelText: "Enter Instrument Name",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorText: _errorInstrumentName),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    TextField(
                      enabled: widget.id.isEmpty,
                      controller: _wherePurchaseController,
                      decoration: InputDecoration(
                        labelText: "Enter Purchased Where?",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorText: _errorwherePurchased,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextField(
                          enabled: widget.id.isEmpty,
                          controller: _purchaseDateController,
                          decoration: InputDecoration(
                            labelText: "Enter Purchased Date",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            errorText: _errorPurchasedDate,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (widget.id.isEmpty) {
                          final DateTime picked = await showDatePicker(
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
                                    mm, '-', dd, '-', yy
                              ])}";
                            });
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    TextField(
                      enabled: widget.id.isEmpty,
                      controller: _serialNumberController,
                      decoration: InputDecoration(
                          labelText: "Enter Serial Number",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorText: _errorSerialNumber),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    TextField(
                      enabled: widget.id.isEmpty,
                      controller: _warrantyController,
                      decoration: InputDecoration(
                          labelText: "Enter Warranty",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorText: _errorWarranty),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextField(
                          enabled: widget.id.isEmpty,
                          controller: _warrantyEndController,
                          decoration: InputDecoration(
                              labelText: "Enter Warranty EndDate",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              errorText: _errorWarrantyEndDate),
                        ),
                      ),
                      onTap: () async {
                        if (widget.id.isEmpty) {
                          final DateTime picked = await showDatePicker(
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
                                yyyy,
                                '-',
                                mm,
                                '-',
                                dd
                              ])}";
                            });
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    TextField(
                      enabled: widget.id.isEmpty,
                      controller: _warrantyReferenceController,
                      decoration: InputDecoration(
                          labelText: "Enter Warranty Reference",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorText: _errorWarrantyReference),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    TextField(
                      controller: _warrantyPhoneController,
                      enabled: widget.id.isEmpty,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Enter Warranty Phone",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorText: _errorWarrantyPhone),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
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
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    widget.id.isEmpty
                        ? RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                                } else if (wendDate.isEmpty) {
                                  _errorWarrantyEndDate = "Cannot be Empty";
                                } else if (wRef.isEmpty) {
                                  _errorWarrantyReference = "Cannot be Empty";
                                } else if (wPh.isEmpty) {
                                  _errorWarrantyPhone = "Cannot be Empty";
                                } else {
                                  Instrument instrument = Instrument(
                                    band_id: selectedBand?.id,
                                    is_insured: _instrumentInsured ? "1" : "0",
                                    name: instrumentName,
                                    purchased_date: purchasedDate,
                                    purchased_from: wherePurchased,
                                    serial_number: sno,
                                    user_id: presenter.serverAPI.userId,
                                    warranty: warranty,
                                    warranty_end_date: wendDate,
                                    warranty_phone: wPh,
                                    warranty_reference: wRef,
                                  );
                                  showLoading();
                                  presenter.addInstrument(instrument);
                                }
                              });
                            },
                            child: Text("Add"),
                          )
                        : Container()
                  ],
                ),
              ),
            )
          ],
        ));
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
    Navigator.of(context).pop();
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

  @override
  void getInstrumentDetails(Instrument instrument) {
    hideLoading();
    setState(() {
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
    });
  }
}
