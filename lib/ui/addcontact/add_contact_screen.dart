import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/ui/addcontact/add_contact_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddContactScreen extends BaseScreen {
  final String id;
  AddContactScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState
    extends BaseScreenState<AddContactScreen, AddContactPresenter>
    implements AddContactContract {
  final relationships = [
    "Agent",
    "Manager",
    "Family",
    "Friends",
    "Promoter",
    "Vendor",
    "Other"
  ];
  final dateToRemember = [
    "Anniversary",
    "Birthday",
    "Expiration",
    "Renewal",
    "Other"
  ];

  var _relationshipType = "Agent", _dateToRememberType = "Anniversary";

  @override
  void initState() {
    super.initState();
    _relationshipController.text = _relationshipType;
    _dateToRememberController.text = _dateToRememberType;
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.contactDetails(widget.id);
      });
    }
  }

  final files = <File>[];

  void _handleRelationshipValueChange(String value) {
    setState(() {
      _relationshipType = value;
      _relationshipController.text = value;
    });
  }

  void _handleDateToRememberValueChange(String value) {
    setState(() {
      _dateToRememberType = value;
      _dateToRememberController.text = value;
    });
  }

  final _nameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _textController = TextEditingController(),
      _relationshipController = TextEditingController(),
      _dateToRememberController = TextEditingController(),
      _emailController = TextEditingController();
  String _errorName,
      _errorPhone,
      _errorEmail,
      _errorText,
      _errorRelationship,
      _errorDateToRemember;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(250, 108, 81, 1.0),
      );

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(250, 108, 81, 1.0),
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
                "${widget.id.isEmpty ? "Add" : ""} Contact",
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
                      TextField(
                        enabled: widget.id.isEmpty,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          labelText: "Name",
                          errorText: _errorName,
                          border: widget.id.isEmpty ? null : InputBorder.none,
                        ),
                        style: textTheme.subhead.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text("Relationship"),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty
                          ? DropdownButton<String>(
                              items: relationships.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _handleRelationshipValueChange,
                              value: _relationshipType,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      _relationshipType == "Other" || widget.id.isNotEmpty
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              controller: _relationshipController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: widget.id.isNotEmpty ? "" : "Other",
                                errorText: _errorRelationship,
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      TextField(
                        enabled: widget.id.isEmpty,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textCapitalization: TextCapitalization.sentences,
                        style: textTheme.subhead.copyWith(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          labelText: "Phone",
                          errorText: _errorPhone,
                          border: widget.id.isEmpty ? null : InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      TextField(
                        enabled: widget.id.isEmpty,
                        controller: _textController,
                        textCapitalization: TextCapitalization.sentences,
                        style: textTheme.subhead.copyWith(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          labelText: "Text",
                          errorText: _errorText,
                          border: widget.id.isEmpty ? null : InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      TextField(
                        enabled: widget.id.isEmpty,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: textTheme.subhead.copyWith(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          labelText: "Email",
                          errorText: _errorEmail,
                          border: widget.id.isEmpty ? null : InputBorder.none,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text("Dates to Remember"),
                      Padding(
                        padding: EdgeInsets.all(widget.id.isEmpty ? 5 : 0),
                      ),
                      widget.id.isEmpty
                          ? DropdownButton<String>(
                              items: dateToRemember.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _handleDateToRememberValueChange,
                              value: _dateToRememberType,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(widget.id.isEmpty ? 3 : 0),
                      ),
                      _dateToRememberType == "Other" || widget.id.isNotEmpty
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              controller: _dateToRememberController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: widget.id.isNotEmpty ? "" : "Other",
                                errorText: _errorDateToRemember,
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Container(),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Upload Media"),
                          ),
                          widget.id.isEmpty
                              ? IconButton(
                                  icon: Icon(Icons.add_a_photo),
                                  onPressed: () {
                                    if (files.length < 2)
                                      getImage();
                                    else
                                      showMessage(
                                          "User can upload upto max 2 media files");
                                  },
                                )
                              : Container()
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty
                          ? files.length > 0
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
                              : Container()
                          : uploadedFiles.length > 0
                              ? SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                    itemCount: uploadedFiles.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String file = uploadedFiles[index];
                                      return Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 80,
                                        width: 150,
                                        child: Image.network(
                                          file,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                      widget.id.isEmpty
                          ? RaisedButton(
                              color: Color.fromRGBO(250, 108, 81, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  String nm = _nameController.text;
                                  String rel = _relationshipController.text;
                                  String dRem = _dateToRememberController.text;
                                  String ph = _phoneController.text;
                                  String txt = _textController.text;
                                  String em = _emailController.text;
                                  _errorDateToRemember = null;
                                  _errorEmail = null;
                                  _errorName = null;
                                  _errorPhone = null;
                                  _errorRelationship = null;
                                  _errorText = null;
                                  if (nm.isEmpty) {
                                    _errorName = "Cannot be empty";
                                  } else if (rel.isEmpty) {
                                    _errorRelationship = "Cannot be empty";
                                    showMessage(_errorRelationship);
                                  } else if (dRem.isEmpty) {
                                    _errorDateToRemember = "Cannot be empty";
                                    showMessage(_errorDateToRemember);
                                  } else if (ph.isEmpty) {
                                    _errorPhone = "Cannot be empty";
                                  } else if (txt.isEmpty) {
                                    _errorText = "Cannot be empty";
                                  } else if (em.isEmpty) {
                                    _errorEmail = "Cannot be empty";
                                  } else if (validateEmail(em)) {
                                    _errorEmail = "Not a Valid Email";
                                  } else {
                                    showLoading();
                                    Contacts contacts = new Contacts();
                                    contacts.name = nm;
                                    contacts.relationship = rel;
                                    contacts.dateToRemember = dRem;
                                    contacts.email = em;
                                    contacts.phone = ph;
                                    contacts.text = txt;
                                    contacts.files = files;
                                    presenter.addContact(contacts);
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
    );
  }

  List<String> uploadedFiles = [];

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
                  files.add(image);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  AddContactPresenter get presenter => AddContactPresenter(this);

  @override
  void onSuccess() {
    hideLoading();
    showMessage("Contact Created Successfully");
    Timer timer = new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  void getContactDetails(Contacts data) {
    hideLoading();
    setState(() {
      uploadedFiles.clear();
      if (data.media1?.isNotEmpty ?? false) uploadedFiles.add(data.media1);
      if (data.media2?.isNotEmpty ?? false) uploadedFiles.add(data.media2);
      _nameController.text = data.name;
      _dateToRememberController.text = data.dateToRemember;
      _emailController.text = data.email;
      _phoneController.text = data.phone;
      _relationshipController.text = data.relationship;
      _textController.text = data.text;
    });
  }
}
