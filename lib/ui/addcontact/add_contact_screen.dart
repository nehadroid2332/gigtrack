import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
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

  var _relationshipType = "Agent";

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _relationshipController.text = _relationshipType;
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.contactDetails(widget.id);
      });
    }
  }

  final files = <File>[];
  final _dateToRememberItems = <DateToRememberData>[];

  void _handleRelationshipValueChange(String value) {
    setState(() {
      _relationshipType = value;
      _relationshipController.text = value;
    });
  }

  final _nameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _textController = TextEditingController(),
      _relationshipController = TextEditingController(),
      _emailController = TextEditingController();
  String _errorName, _errorPhone, _errorEmail, _errorText, _errorRelationship;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(82, 149, 171, 1.0),
      );

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(82, 149, 171, 1.0),
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
                          labelText: "Mobile/Text",
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Dates to Remember"),
                          ),
                          widget.id.isEmpty
                              ? IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _dateToRememberItems
                                          .add(DateToRememberData());
                                    });
                                  },
                                )
                              : Container()
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(widget.id.isEmpty ? 5 : 0),
                      ),
                      ListView.builder(
                        itemCount: _dateToRememberItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          DateToRememberData data = _dateToRememberItems[index];
                          final _dateToRememberController =
                              TextEditingController();
                          final _dateToRememberDateController =
                              TextEditingController();
                          _dateToRememberController.addListener(() {
                            data.type = _dateToRememberController.text;
                            _dateToRememberItems[index] = data;
                          });
                          _dateToRememberDateController.addListener(() {
                            data.date = selectedDate.millisecondsSinceEpoch;
                            _dateToRememberItems[index] = data;
                          });
                          void _handleDateToRememberValueChange(String value) {
                            setState(() {
                              data.type = value;
                              _dateToRememberItems[index] = data;
                            });
                          }

                          _dateToRememberController.text = data.type;
                          _dateToRememberDateController.text = formatDate(
                              DateTime.fromMillisecondsSinceEpoch(data.date),
                              [mm, '-', dd, '-', yy]);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DropdownButton<String>(
                                items: dateToRemember.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: _handleDateToRememberValueChange,
                                value: data.type,
                              ),
                              data.type == "Other"
                                  ? TextField(
                                      enabled: widget.id.isEmpty,
                                      controller: _dateToRememberController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              202, 208, 215, 1.0),
                                        ),
                                        labelText:
                                            widget.id.isNotEmpty ? "" : "Other",
                                        border: widget.id.isEmpty
                                            ? null
                                            : InputBorder.none,
                                      ),
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.black,
                                      ),
                                    )
                                  : Container(),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2015, 8),
                                      lastDate: DateTime(2101));
                                  if (picked != null)
                                    setState(() {
                                      selectedDate = picked;
                                      _dateToRememberDateController.text =
                                          formatDate(
                                              picked, [mm, '-', dd, '-', yy]);
                                    });
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    enabled: widget.id.isEmpty,
                                    controller: _dateToRememberDateController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText:
                                          widget.id.isNotEmpty ? "" : "Date",
                                      border: widget.id.isEmpty
                                          ? null
                                          : InputBorder.none,
                                    ),
                                    style: textTheme.subhead.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Add Picture"),
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
                              color: Color.fromRGBO(82, 149, 171, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  String nm = _nameController.text;
                                  String rel = _relationshipController.text;
                                  String ph = _phoneController.text;
                                  String txt = _textController.text;
                                  String em = _emailController.text;
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
                                    contacts.email = em;
                                    contacts.phone = ph;
                                    contacts.text = txt;
                                    contacts.files = files;
                                    contacts.dateToRemember =
                                        _dateToRememberItems;
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
      uploadedFiles.addAll(data.uploadedFiles);
      _dateToRememberItems.clear();
      _dateToRememberItems.addAll(data.dateToRemember);
      _nameController.text = data.name;
      // _dateToRememberController.text = data.dateToRemember;
      _emailController.text = data.email;
      _phoneController.text = data.phone;
      _relationshipController.text = data.relationship;
      _textController.text = data.text;
    });
  }

  @override
  void onUpdate() {
    showMessage("Updated Successfully");
  }
}

class DateToRememberData {
  String type = "Anniversary";
  int date = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map();
    data['type'] = type;
    data['date'] = date;
    return data;
  }

  DateToRememberData();

  DateToRememberData.fromJSON(item) {
    type = item['type'];
    date = item['date'];
  }
}
