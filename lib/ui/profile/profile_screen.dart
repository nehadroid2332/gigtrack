import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/ui/profile/profile_presenter.dart';
import 'package:gigtrack/utils/NumberTextInputFormatter.dart';
import 'package:image_picker/image_picker.dart';

NumberTextInputFormatter phoneNumberFormatter = NumberTextInputFormatter(1);

class ProfileScreen extends BaseScreen {
  ProfileScreen(AppListener appListener) : super(appListener);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState
    extends BaseScreenState<ProfileScreen, ProfilePresenter>
    implements ProfileContract {
  String currentTimeZone;
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _addressController = TextEditingController(),
      _dep18Controller = TextEditingController(),
      _phoneController = TextEditingController(),
      _cityController = TextEditingController(),
      _stateController = TextEditingController(),
      _zipController = TextEditingController(),
      _guardianEmailController = TextEditingController(),
      _guardianNameController = TextEditingController(),
      _primaryInstrumentController = TextEditingController(),
      _websiteController = TextEditingController();
  String _errorEmail,
      _errorPassword,
      _errorPhone,
      _errorGuardianName,
      _errorState,
      _errorZip,
      _errorGuardianEmail,
      _errorWebsite;
  String _errorFirstName,
      _errorLastName,
      _errorAddress,
      _errorCity,
      _errorPrimaryInstrument;

  File _image;
  bool isEdit = false;

  String _imageUrl;

  bool isUnderAge = false;

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
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEdit = !isEdit;
                  });
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(0),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(5),
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Profile",
                    style: textTheme.headline.copyWith(
                      color: widget.appListener.primaryColorDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: _image != null ||
                              _imageUrl != null
                             
                          ? new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: _imageUrl != null
                                    ? NetworkImage(_imageUrl)
                                    : FileImage(_image),
                              ),
                            )
                          : null,
                      child: _image == null &&
                              (_imageUrl == null || _imageUrl.isEmpty)
                          ? Icon(
                              Icons.account_circle,
                              size: 130,
                            )
                          : null,
                    ),
                    onTap: isEdit ? getImage : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: isEdit
                          ? TextField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: "FirstName",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(169, 176, 187, 1.0),
                                ),
                                errorText: _errorFirstName,
                              ),
                            )
                          : Text(
                              _firstNameController.text +
                                  ' ' +
                                  _lastNameController.text,
                              textAlign: TextAlign.center,
                              style: textTheme.title,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    isEdit
                        ? Expanded(
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
                        : Container()
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                isEdit
                    ? TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          // Fit the validating format.
                          phoneNumberFormatter,
                        ],
                        decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(169, 176, 187, 1.0),
                            ),
                            errorText: _errorPhone),
                      )
                    : Text(
                        _phoneController.text,
                        textAlign: TextAlign.center,
                        style: textTheme.title,
                      ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                isEdit
                    ? TextField(
                        controller: _emailController,
                        enabled: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Color.fromRGBO(169, 176, 187, 1.0),
                            ),
                            errorText: _errorEmail),
                      )
                    : Text(
                        _emailController.text,
                        textAlign: TextAlign.center,
                        style: textTheme.title,
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
                isEdit
                    ? TextField(
                        controller: _zipController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Zip Code",
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(169, 176, 187, 1.0),
                          ),
                          errorText: _errorZip,
                        ),
                      )
                    : Text(
                        _zipController.text,
                        textAlign: TextAlign.center,
                        style: textTheme.title,
                      ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                isEdit
                    ? Container()
                    : Text(
                        "Local Timezone- $currentTimeZone",
                        textAlign: TextAlign.center,
                        style: textTheme.title,
                      ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                isUnderAge
                    ? isEdit
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
                        : Text(
                            _guardianNameController.text,
                            textAlign: TextAlign.center,
                            style: textTheme.title,
                          )
                    : Container(),
                isUnderAge
                    ? isEdit
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
                        : Text(
                            _guardianEmailController.text,
                            textAlign: TextAlign.center,
                            style: textTheme.title,
                          )
                    : Container(),
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
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                ),
                isEdit
                    ? Wrap(
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
                                  "Update",
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
                                  presenter.updateUserProfile(
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
                                      _dep18Controller.text);
                                }
                              });
                            },
                          )
                        ],
                      )
                    : Container(),
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
  void initState() {
    super.initState();
    getTimezone();
    presenter.getUserProfile();
  }

  @override
  ProfilePresenter get presenter => ProfilePresenter(this);

  @override
  void onUpdate() {
    hideLoading();
    presenter.getUserProfile();
  }

  @override
  void onUserProfile(User user) {
    setState(() {
      _zipController.text = user.zipcode;
      _addressController.text = user.address;
      _cityController.text = user.city;
      _stateController.text = user.state;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _imageUrl = user.profilePic;
      _primaryInstrumentController.text = user.primaryInstrument;
      _lastNameController.text = user.lastName;
      _firstNameController.text = user.firstName;
      isUnderAge = user.isUnder18Age ?? false;
      _guardianEmailController.text = user.guardianEmail;
      _guardianNameController.text = user.guardianName;
    });
  }

  getTimezone() async {
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

    setState(() {
      currentTimeZone;
    });
  }
}
