import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_presenter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

class AddInstrumentScreen extends BaseScreen {
  AddInstrumentScreen(AppListener appListener) : super(appListener);

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
                    "Add Instrument",
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
                          context, Screens.ADDSONG.toString(),
                          replace: true,
                          transition: TransitionType.inFromRight);
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
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Instrument Name",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _instrumentNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Instrument Name",
                          errorText: _errorInstrumentName),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Purchased Where?",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _wherePurchaseController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Purchased Where?",
                          errorText: _errorwherePurchased),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Purchased Date",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _purchaseDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter Purchased Date",
                            errorText: _errorPurchasedDate,
                          ),
                        ),
                      ),
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                          context: context,
                          firstDate: _date,
                          initialDate: _date,
                          lastDate: DateTime(2022),
                        );
                        if (picked != null) {
                          setState(() {
                            //_date = picked;
                            _purchaseDateController.text =
                                "${formatDate(picked, [
                              yyyy,
                              '-',
                              mm,
                              '-',
                              dd
                            ])}";
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Serial Number",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _serialNumberController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Serial Number",
                          errorText: _errorSerialNumber),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Warranty",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _warrantyController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Warranty",
                          errorText: _errorWarranty),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Warranty EndDate",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _warrantyEndController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter Warranty EndDate",
                              errorText: _errorWarrantyEndDate),
                        ),
                      ),
                      onTap: () async {
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
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Warranty Reference",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _warrantyReferenceController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Warranty Reference",
                          errorText: _errorWarrantyReference),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Warranty Phone",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _warrantyPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Warranty Phone",
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
                          value: _instrumentInsured,
                        ),
                        Text("Is Instrument Insured?")
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textColor: Colors.white,
                      onPressed: () {
                        String instrumentName = _instrumentNameController.text;
                        String wherePurchased = _wherePurchaseController.text;
                        String purchasedDate = _purchaseDateController.text;
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
                            showLoading();
                            presenter.addInstrument();
                          }
                        });
                      },
                      child: Text("Add"),
                    )
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
    hideLoading();
    widget.appListener.router.navigateTo(context, Screens.ADDSONG.toString());
  }
}
