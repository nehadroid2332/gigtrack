import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/signup/signup_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends BaseScreen {
//  final FirebaseAnalytics analytics;
//  final FirebaseAnalyticsObserver observer;
  SignUpScreen(AppListener appListener) : super(appListener);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseScreenState<SignUpScreen, SignUpPresenter>
    implements SignUpContract {
  bool isUnderAge = false;

  _SignUpScreenState();
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _addressController = TextEditingController(),
      _phoneController = TextEditingController(),
      _cityController = TextEditingController(),
      _stateController = TextEditingController(),
      _zipController = TextEditingController(),
      _guardianNameController = TextEditingController(),
      _guardianEmailController = TextEditingController(),
      _primaryInstrumentController = TextEditingController(),
      _websiteController = TextEditingController();
  String _errorEmail,
      _errorPassword,
      _errorPhone,
      _errorState,
      _errorGuardianName,
      _errorGuardianEmail,
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
      color: Colors.transparent,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back,
                      color: widget.appListener.primaryColorDark,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset(
                'assets/images/music.png',
                height: 100,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                    style: textTheme.headline.copyWith(
                      color: widget.appListener.primaryColorDark,
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Fill below details",
                    style: textTheme.headline.copyWith(
                      color: Color.fromRGBO(99, 108, 119, 1.0),
                      fontSize: 23,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
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
                    onTap: getImage,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: "FirstName",
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(169, 176, 187, 1.0),
                          ),
                          errorText: _errorFirstName,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                            labelText: "LastName",
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(169, 176, 187, 1.0),
                            ),
                            errorText: _errorLastName),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: "Phone",
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(169, 176, 187, 1.0),
                      ),
                      errorText: _errorPhone),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(169, 176, 187, 1.0),
                      ),
                      errorText: _errorEmail),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(169, 176, 187, 1.0),
                    ),
                    errorText: _errorPassword,
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
//                TextField(
//                  controller: _addressController,
//                  decoration: InputDecoration(
//                    labelText: "Address",
//                    labelStyle: TextStyle(
//                      color: Color.fromRGBO(169, 176, 187, 1.0),
//                    ),
//                    errorText: _errorAddress,
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                TextField(
//                  controller: _cityController,
//                  decoration: InputDecoration(
//                    labelText: "City",
//                    labelStyle: TextStyle(
//                      color: Color.fromRGBO(169, 176, 187, 1.0),
//                    ),
//                    errorText: _errorCity,
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                TextField(
//                  controller: _stateController,
//                  decoration: InputDecoration(
//                    labelStyle: TextStyle(
//                      color: Color.fromRGBO(169, 176, 187, 1.0),
//                    ),
//                    labelText: "State",
//                    errorText: _errorState,
//                  ),
//                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                TextField(
                  controller: _zipController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Zip Code",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(169, 176, 187, 1.0),
                    ),
                    errorText: _errorZip,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
//                TextField(
//                  controller: _primaryInstrumentController,
//                  decoration: InputDecoration(
//                      labelText: "Primary Instrument",
//                      labelStyle: TextStyle(
//                        color: Color.fromRGBO(169, 176, 187, 1.0),
//                      ),
//                      errorText: _errorPrimaryInstrument),
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                TextField(
//                  controller: _websiteController,
//                  decoration: InputDecoration(
//                    labelText: "Website",
//                    labelStyle: TextStyle(
//                      color: Color.fromRGBO(169, 176, 187, 1.0),
//                    ),
//                    errorText: _errorWebsite,
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      onChanged: (bool value) {
                        setState(() {
                          isUnderAge = value;
                        });
                      },
                      value: isUnderAge,
                    ),
                    Text("Are you under 18 age?")
                  ],
                ),
                isUnderAge
                    ? TextField(
                        controller: _guardianNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Dependent Name",
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(169, 176, 187, 1.0),
                          ),
                          errorText: _errorGuardianName,
                        ),
                      )
                    : Container(),
                isUnderAge
                    ? TextField(
                        controller: _guardianEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Dependent Email",
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(169, 176, 187, 1.0),
                          ),
                          errorText: _errorGuardianEmail,
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                ),
                Wrap(
                  children: <Widget>[
                    RaisedButton(
                      color: Color.fromRGBO(255, 0, 104, 1.0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Sign Up",
                            style: textTheme.title.copyWith(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 19,
                          )
                        ],
                      ),
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
                          String gEmail = _guardianEmailController.text;
                          String gName = _guardianNameController.text;
                          _errorFirstName = null;
                          _errorAddress = null;
                          _errorCity = null;
                          _errorGuardianEmail = null;
                          _errorGuardianName = null;
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
                          }
//                          else if (address.isEmpty) {
//                            _errorAddress = "Cannot be empty";
//                          } else if (city.isEmpty) {
//                            _errorCity = "Cannot be empty";
//                          }
//                          else if (state.isEmpty) {
//                            _errorState = "Cannot be empty";
//                          }
                          else if (zip.isEmpty) {
                            _errorZip = "Cannot be empty";
                          } else if (gName.isEmpty) {
                            _errorGuardianName = "Cannot be empty";
                          } else if (gEmail.isEmpty) {
                            _errorGuardianEmail = "Cannot be empty";
                          }
//                          else if (primaryInstrument.isEmpty) {
//                            _errorPrimaryInstrument = "Cannot be empty";
//                          } else if (website.isEmpty) {
//                            _errorWebsite = "Cannot be empty";
//                          }
                          //  else if (_image == null) {
                          //   showMessage("Please Select Image");
                          // }
                          else {
                            showLoading();
                            presenter.signUpUser(
                                fname,
                                lname,
                                email,
                                password,
                                phone,
                                address,
                                city,
                                state,
                                zip,
                                _image,
                                primaryInstrument,
                                isUnderAge,
                                gName,
                                gEmail);
                          }
                        });
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                  child: Center(
                      child: RichText(
                    text: TextSpan(
                      text: 'By signing up, you agree to our',
                      style: TextStyle(color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => widget.appListener.router
                                  .navigateTo(
                                      context, Screens.PRIVACY.toString())),
                        TextSpan(
                          text: '& Privacy Policy.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => widget.appListener.router
                                .navigateTo(
                                    context, Screens.PRIVACY.toString()),
                        ),
                      ],
                    ),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                )
              ],
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
    // widget.appListener.router
    // .navigateTo(context, Screens.ADDBAND.toString() + "/23");
    //   _sendAnalyticsEvent();
    Navigator.pop(context);
  }
//  Future<void> _sendAnalyticsEvent() async {
//    await analytics.logEvent(
//      name: 'signup_event',
//      parameters: <String, dynamic>{
//        'signup_status': true,
//      },
//    );
//
//  }
}
