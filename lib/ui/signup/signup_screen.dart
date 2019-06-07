import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/signup/signup_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends BaseScreen {
  SignUpScreen(AppListener appListener) : super(appListener);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseScreenState<SignUpScreen, SignUpPresenter>
    implements SignUpContract {
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _addressController = TextEditingController(),
      _phoneController = TextEditingController(),
      _cityController = TextEditingController(),
      _stateController = TextEditingController(),
      _zipController = TextEditingController(),
      _primaryInstrumentController = TextEditingController(),
      _websiteController = TextEditingController();
  String _errorEmail,
      _errorPassword,
      _errorPhone,
      _errorState,
      _errorZip,
      _errorWebsite;
  String _errorFirstName,
      _errorLastName,
      _errorAddress,
      _errorCity,
      _errorPrimaryInstrument;

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
                  "SignUp",
                  style: textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "FirstName",
                            style: textTheme.subhead.copyWith(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "LastName",
                            style: textTheme.subhead.copyWith(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "Enter FirstName",
                              errorText: _errorFirstName),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "Enter LastName",
                              errorText: _errorLastName),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Phone",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Phone",
                        errorText: _errorPhone),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Email",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Email",
                        errorText: _errorEmail),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Password",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Password",
                        errorText: _errorPassword),
                    obscureText: true,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Address",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Address",
                        errorText: _errorAddress),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "City",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter City",
                        errorText: _errorCity),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "State",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _stateController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter State",
                        errorText: _errorState),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Zip Code",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Zip Code",
                        errorText: _errorZip),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Primary Instrument",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _primaryInstrumentController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Primary Instrument",
                        errorText: _errorPrimaryInstrument),
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
                        border: OutlineInputBorder(),
                        hintText: "Enter Website",
                        errorText: _errorWebsite),
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
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String fname = _firstNameController.text;
                        String lname = _lastNameController.text;
                        String phone = _phoneController.text;
                        String address = _addressController.text;
                        String city = _cityController.text;
                        String state = _stateController.text;
                        String zip = _zipController.text;
                        String primaryInstrument =
                            _primaryInstrumentController.text;
                        String website = _websiteController.text;
                        _errorFirstName = null;
                        _errorAddress = null;
                        _errorCity = null;
                        _errorEmail = null;
                        _errorLastName = null;
                        _errorPassword = null;
                        _errorPhone = null;
                        _errorPrimaryInstrument = null;
                        _errorState = null;
                        _errorWebsite = null;
                        _errorZip = null;
                        if (fname.isEmpty) {
                          _errorFirstName = "Cannot be empty";
                        } else if (lname.isEmpty) {
                          _errorLastName = "Cannot be empty";
                        } else if (email.isEmpty) {
                          _errorEmail = "Cannot be empty";
                        } else if (password.isEmpty) {
                          _errorPassword = "Cannot be empty";
                        } else if (validateEmail(email)) {
                          _errorEmail = "Not a Valid Email";
                        } else if (password.length < 6) {
                          _errorPassword =
                              "Password must be more than 6 character";
                        } else if (phone.isEmpty) {
                          _errorPhone = "Cannot be empty";
                        } else if (address.isEmpty) {
                          _errorAddress = "Cannot be empty";
                        } else if (city.isEmpty) {
                          _errorCity = "Cannot be empty";
                        } else if (state.isEmpty) {
                          _errorState = "Cannot be empty";
                        } else if (zip.isEmpty) {
                          _errorZip = "Cannot be empty";
                        } else if (primaryInstrument.isEmpty) {
                          _errorPrimaryInstrument = "Cannot be empty";
                        } else if (website.isEmpty) {
                          _errorWebsite = "Cannot be empty";
                        } else {
                          showLoading();
                          presenter.signUpUser(fname, lname, email, password,
                              phone, address, city, state, zip, _image);
                        }
                      });
                    },
                    child: Text("Sign Up"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  SignUpPresenter get presenter => SignUpPresenter(this);

  @override
  void signUpSuccess() {
    hideLoading();
    showMessage("Register Successfully");
    // widget.appListener.router.navigateTo(context, Screens.ADDBAND.toString());
  }
}
