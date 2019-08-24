import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addcontact/add_contact_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class AddContactScreen extends BaseScreen {
  final String id;
  AddContactScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState
    extends BaseScreenState<AddContactScreen, AddContactPresenter> {
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

  var _relationshipType, _dateToRememberType;

  void _handleRelationshipValueChange(String value) {
    setState(() {
      _relationshipType = value;
    });
  }

  void _handleDateToRememberValueChange(String value) {
    setState(() {
      _dateToRememberType = value;
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
                      Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: relationships
                            .map<Widget>(
                              (r) => InkWell(
                                onTap: widget.id.isEmpty
                                    ? () {
                                        _handleRelationshipValueChange(r);
                                      }
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: _relationshipType == r
                                          ? Color.fromRGBO(209, 244, 236, 1.0)
                                          : Color.fromRGBO(244, 246, 248, 1.0),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: _relationshipType == r
                                              ? Color.fromRGBO(
                                                  70, 206, 172, 1.0)
                                              : Color.fromRGBO(
                                                  244, 246, 248, 1.0))),
                                  child: Text(
                                    '$r',
                                    style: new TextStyle(
                                      fontSize: 16.0,
                                      color: _relationshipType == r
                                          ? Color.fromRGBO(70, 206, 172, 1.0)
                                          : Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      _relationshipType == "Other"
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              controller: _relationshipController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Other",
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
                      Text("Dates to Remember"),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: dateToRemember
                            .map<Widget>(
                              (r) => InkWell(
                                onTap: widget.id.isEmpty
                                    ? () {
                                        _handleDateToRememberValueChange(r);
                                      }
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: _dateToRememberType == r
                                          ? Color.fromRGBO(209, 244, 236, 1.0)
                                          : Color.fromRGBO(244, 246, 248, 1.0),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: _dateToRememberType == r
                                              ? Color.fromRGBO(
                                                  70, 206, 172, 1.0)
                                              : Color.fromRGBO(
                                                  244, 246, 248, 1.0))),
                                  child: Text(
                                    '$r',
                                    style: new TextStyle(
                                      fontSize: 16.0,
                                      color: _dateToRememberType == r
                                          ? Color.fromRGBO(70, 206, 172, 1.0)
                                          : Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      _dateToRememberType == "Other"
                          ? TextField(
                              enabled: widget.id.isEmpty,
                              controller: _dateToRememberController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Other",
                                errorText: _errorDateToRemember,
                                border:
                                    widget.id.isEmpty ? null : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Container(),
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
                                  } else if (dRem.isEmpty) {
                                    _errorDateToRemember = "Cannot be empty";
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

  @override
  AddContactPresenter get presenter => AddContactPresenter(this);
}
