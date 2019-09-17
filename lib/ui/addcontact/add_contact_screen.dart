import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/ui/addcontact/add_contact_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';
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
  bool _currentRelation = false;
  bool defaultdateview = false;
  bool _adddefaultlikes= false;
  bool _isphoneNumber=false;

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
      if (value == "Other") {
        _currentRelation = true;
      } else {
        _currentRelation = false;
      }
      _relationshipController.text = value;
    });
  }

  final _nameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _textController = TextEditingController(),
      _relationshipController = TextEditingController(),
      _otherRelationshipController = TextEditingController(),
      _emailController = TextEditingController();
  String _errorName, _errorPhone, _errorEmail, _errorText, _errorRelationship;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(82, 149, 171, 1.0),
      );

  final likesList = <String>[
    "Food",
    "Snacks",
    "Hobbies",
    "Sports",
    "Entertainment",
    "Clothes",
    "Others"
  ];
  Map<String, String> selectedLikesMap = {};

  @override
  Widget buildBody() {
    List<Widget> items2 = [];
    for (String s in likesList) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: selectedLikesMap.containsKey(s)
                    ? Colors.white
                    : Color.fromRGBO(82, 149, 171, 1.0)),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selectedLikesMap.containsKey(s)
                ? Color.fromRGBO(82, 149, 171, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (selectedLikesMap.containsKey(s)) {
              selectedLikesMap.remove(s);
            } else
              selectedLikesMap[s] = null;
          });
        },
      ));
    }
    List<Widget> likesTextFields = [];
    for (String key in selectedLikesMap.keys) {
      String val = selectedLikesMap[key];
      final txtController = TextEditingController(text: val);
      txtController.addListener(() {
        setState(() {
          selectedLikesMap[key] = txtController.text;
        });
      });
      likesTextFields.add(Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(key),
          ),
          Padding(
            padding: EdgeInsets.all(4),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: txtController,
            ),
          )
        ],
      ));
    }
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
                      widget.id.isEmpty
                          ? Container()
                          : Text(
                              "Name",
                              textAlign: widget.id.isEmpty
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.subtitle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      widget.id.isEmpty
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Name",
                                errorText: _errorName,
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              _nameController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        "Relationship",
                        textAlign: widget.id.isEmpty
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(widget.id.isEmpty ? 5 : 0),
                      ),
                      widget.id.isEmpty
                          ? DropdownButton<String>(
                              items: relationships.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                              onChanged: _handleRelationshipValueChange,
                              value: _relationshipType,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      _currentRelation
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              controller: _otherRelationshipController,
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
                          : widget.id.isNotEmpty
                              ? Text(
                                  _relationshipController.text,
                                  textAlign: TextAlign.center,
                                )
                              : Container(),

//                      Padding(
//                        padding: EdgeInsets.all(5),
//                      ),
                      widget.id.isEmpty
                          ? Container()
                          : Text(
                        "Mobile/Text",
                        textAlign: widget.id.isEmpty
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      widget.id.isEmpty
                          ? TextField(
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
                          border:
                          widget.id.isEmpty ? null : InputBorder.none,
                        ),
                      )
                          : Text(
                        _textController.text,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      ShowUp(
                        child: !_isphoneNumber
                            ? new GestureDetector(
                          onTap: () {
                            setState(() {
                              _isphoneNumber = true;
                            });
                          },
                          child: widget.id.isEmpty
                              ? Text(
                            "Click here to add phone number",
                            style: textTheme.display1.copyWith(
                                color: widget
                                    .appListener.primaryColorDark,
                                fontSize: 14),
                          )
                              : Container(),
                        )
                            : Container(),
                        delay: 1000,
                      ),
                      widget.id.isEmpty && !_isphoneNumber
                          ? Container()
                          : Text(
                              "Phone",
                              textAlign: widget.id.isEmpty
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.subtitle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      widget.id.isEmpty && _isphoneNumber
                          ? TextField(
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
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                            )
                          : _phoneController.text.isNotEmpty?Text(
                              _phoneController.text,
                              textAlign: TextAlign.center,
                            ):Container(),
                      Padding(
                        padding: _isphoneNumber?EdgeInsets.all(5):EdgeInsets.all(0),
                      ),
                      widget.id.isEmpty
                          ? Container()
                          : Text(
                              "Email",
                              textAlign: widget.id.isEmpty
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.subtitle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      widget.id.isEmpty
                          ? TextField(
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
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                            )
                          : Text(
                              _emailController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Dates to Remember",
                              style: textTheme.subtitle
                                  .copyWith(fontWeight: FontWeight.bold),
                              textAlign: widget.id.isEmpty
                                  ? TextAlign.left
                                  : TextAlign.center,
                            ),
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
                          void _handleDateToRememberValueChange(String value) {
                            setState(() {
                              data.type = value;
                              _dateToRememberItems[index] = data;
                            });
                          }

                          _dateToRememberController.text = data.type;
                          _dateToRememberDateController.text = defaultdateview
                              ? formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data.date),
                                  [mm, '-', dd, '-', yy])
                              : "";
                          return Column(
                            crossAxisAlignment: widget.id.isEmpty
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.center,
                            children: <Widget>[
                              widget.id.isEmpty
                                  ? DropdownButton<String>(
                                      items: dateToRemember.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged:
                                          _handleDateToRememberValueChange,
                                      value: data.type,
                                    )
                                  : Text(
                                      data.type,
                                      textAlign: TextAlign.center,
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
                              widget.id.isEmpty
                                  ? GestureDetector(
                                      onTap: () async {
                                        final DateTime picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2015, 8),
                                                lastDate: DateTime(2101));
                                        if (picked != null)
                                          setState(() {
                                            defaultdateview = true;
                                            data.date =
                                                picked.millisecondsSinceEpoch;
                                            _dateToRememberDateController.text =
                                                formatDate(picked,
                                                    [mm, '-', dd, '-', yy]);
                                            _dateToRememberItems[index] = data;
                                          });
                                      },
                                      child: AbsorbPointer(
                                        child: TextField(
                                          enabled: widget.id.isEmpty,
                                          controller:
                                              _dateToRememberDateController,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  202, 208, 215, 1.0),
                                            ),
                                            labelText: widget.id.isNotEmpty
                                                ? ""
                                                : "Date",
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
                                  : Text(_dateToRememberDateController.text)
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "${widget.id.isEmpty ? 'Add' : ''} Pictures",
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                                    files.removeAt(index);
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
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Likes",
                              style: textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          widget.id.isEmpty
                              ? _adddefaultlikes?Container():IconButton(
                            icon: Icon(Icons.add_circle),
                            onPressed: () {
                              _showDialog();
                              },
                          )
                              : Container()
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                      ),
                      _adddefaultlikes?Wrap(
                        children: items2,
                      ):Container(),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                      Column(
                        children: likesTextFields,
                      ),
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
                  if (image != null) files.add(image);
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
                  if (image != null) files.add(image);
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
  // user defined function
  void _showDialog() {
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
            "Add Likes",
            textAlign: TextAlign.center,
          ),
          content:
          new Text("Do you want to add likes for contact?"),
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
              color: Color.fromRGBO(82, 149, 171, 1.0),
              onPressed: () {
                setState(() {
                  _adddefaultlikes=true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
