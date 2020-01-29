import 'dart:async';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/ui/addcontact/add_contact_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class AddContactScreen extends BaseScreen {
  final String id;
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  AddContactScreen(
    AppListener appListener, {
    this.id,
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "");

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState
    extends BaseScreenState<AddContactScreen, AddContactPresenter>
    implements AddContactContract {
  final relationships = [
    "Select",
    "Agent",
    "Manager",
    "Family",
    "Friend",
    "Promoter",
    "Vendor",
    "Spouse",
    "Other"
  ];
  final dateToRemember = [
    "Select",
    "Anniversary",
    "Birthday",
    "Expiration",
    "Renewal",
    "Other"
  ];

  var _relationshipType = "Select";
  bool _currentRelation = false;
  bool _adddefaultlikes = false;
  bool _isphoneNumber = false;
  bool _isclicktoLikes = false;
  bool _isdateToRemmber = false;
  bool _isCompanyName = false;

  String userId;

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

  bool qDarkmodeEnable = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    checkThemeMode();
  }

  void checkThemeMode() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var qdarkMode = MediaQuery.of(context).platformBrightness;
      if (qdarkMode == Brightness.dark) {
        setState(() {
          qDarkmodeEnable = true;
        });
      } else {
        setState(() {
          qDarkmodeEnable = false;
        });
      }
    }
  }

  var files = <String>[];
  final _dateToRememberItems = <DateToRememberData>[];

  void _handleRelationshipValueChange(String value) {
    setState(() {
      _relationshipType = value;
      if (value == "Other") {
        _currentRelation = true;
        _otherRelationshipController.text = " ";
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
      _companyNameController = TextEditingController(),
      _notesController = TextEditingController(),
      _noteContactController = TextEditingController(),
      _emailController = TextEditingController();
  String _errorName, _errorPhone, _errorEmail, _errorText, _errorRelationship;
  bool isEdit = false;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (isEdit) {
              final check = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Do you want to save changes?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: qDarkmodeEnable
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      RaisedButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: qDarkmodeEnable
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        color: Color.fromRGBO(3, 218, 157, 1.0),
                        onPressed: () {
                          _submitContact();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
              if (check) {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(3, 218, 157, 1.0),
        actions: <Widget>[
          Container(
              alignment: Alignment.center,
              width: widget.id.isEmpty
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Text(
                  "${widget.id.isEmpty ? "Add" : isEdit ? "Edit" : ""} Contact",
                  textAlign: TextAlign.center,
                  style: textTheme.headline.copyWith(
                    color: Colors.white,
                  ),
                ),
              )),
          subContact == null
              ? widget.id.isEmpty
                  ? Container()
                  : (widget.isLeader ||
                          userId == presenter.serverAPI.currentUserId)
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEdit = !isEdit;
                              _adddefaultlikes = true;
                            });
                          },
                        )
                      : Container()
              : Container(),
          subContact == null
              ? widget.id.isEmpty
                  ? Container()
                  : (widget.isLeader ||
                          userId == presenter.serverAPI.currentUserId)
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (widget.id == null || widget.id.isEmpty) {
                              showMessage("Id cannot be null");
                            } else {
                              _showDialogConfirm();
//                      presenter.contactDelete(id);
//                      Navigator.of(context).pop();
                            }
                          },
                        )
                      : Container()
              : Container()
        ],
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
  SubContact subContact;
  List<SubContact> subContacts = [];

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
                    : Color.fromRGBO(3, 218, 157, 1.0)),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selectedLikesMap.containsKey(s)
                ? Color.fromRGBO(3, 218, 157, 1.0)
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
              selectedLikesMap[s] = "";
          });
        },
      ));
    }
    List<Widget> likesTextFields = [];
    for (String key in selectedLikesMap.keys) {
      String val = selectedLikesMap[key];
      final txtController = TextEditingController(text: val);
      txtController.addListener(() {
//        setState(() {
//          selectedLikesMap[key] = txtController.text;
//          txtController.value = txtController.value.copyWith(text:txtController.text,);
//
//        });
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
              textCapitalization: TextCapitalization.words,
              controller: txtController,
              onChanged: (text) {
                selectedLikesMap[key] = text;
                //txtController.text= text.replaceAll(" ", ',');
              },
            ),
          )
        ],
      ));
    }
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 4.5),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(3, 218, 157, 1.0),
//              image: DecorationImage(
//                image: AssetImage("assets/images/newupdated.png"),
//                fit: BoxFit.cover,
//              ),
            ),
            // color: Color.fromRGBO(3, 54, 255, 1.0),
            height: height / 4.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: subContact != null
                      ? ListView(
                          padding: EdgeInsets.all(10),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            TextField(
                              style: textTheme.title.apply(
                                  color: qDarkmodeEnable
                                      ? Colors.white
                                      : Colors.black87),
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: "Add Note",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                  fontSize: 18,
                                ),
                              ),
                              controller: _noteContactController,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  subContact.title =
                                      _noteContactController.text;
                                  subContact.id = randomString(12);
                                  subContact.createdDate =
                                      DateTime.now().millisecondsSinceEpoch;
                                  subContacts.add(subContact);
                                  presenter.addContactNote(
                                      subContacts, widget.id);
                                  subContact = null;
                                });
                              },
                              color: Color.fromRGBO(3, 218, 157, 1.0),
                              child: Text(
                                "Submit",
                                style: textTheme.headline.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textColor: Colors.white,
                            )
                          ],
                        )
                      : ListView(
                          padding: EdgeInsets.only(
                              left: 10, right: 20, top: 10, bottom: 15),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : files.length > 0
                                    ? SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                          itemCount: files.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String file = files[index];
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              height: 130,
                                              width: width - 50,
                                              child: Image.network(
                                                file,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                            Padding(
                              padding: EdgeInsets.all(7),
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText: "Name",
                                      errorText: _errorName,
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                    style: textTheme.subhead.copyWith(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                : Column(
                                    children: <Widget>[
//                                Expanded(
//                                  flex: 5,
//                                  child: Text(
//                                    "Name",
//                                    textAlign: TextAlign.right,
//                                    style: textTheme.subtitle.copyWith(
//                                      fontWeight: FontWeight.w600,
//                                    ),
//                                  ),
//                                ),
//                                Expanded(
//                                  flex: 1,
//                                  child: Text(
//                                    " - ",
//                                    textAlign: TextAlign.center,
//                                  ),
//                                ),
                                      Center(
                                        child: Text(
                                          _nameController.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                            Padding(
                              padding: (widget.id.isNotEmpty) &&
                                      (_companyNameController.text.isEmpty) &&
                                      !isEdit
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(
                                      widget.id.isEmpty || isEdit ? 4 : 4),
                            ),
                            Padding(
                              padding: widget.id.isEmpty
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(0),
                            ),
                            ShowUp(
                              child: !_isCompanyName
                                  ? new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isCompanyName = true;
                                        });
                                      },
                                      child: widget.id.isEmpty || isEdit
                                          ? Text(
                                              "Click here to add Company Name",
                                              style: textTheme.display1
                                                  .copyWith(
                                                      color: Colors.red,
                                                      fontSize: 16),
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              delay: 1000,
                            ),
                            widget.id.isEmpty && !_isCompanyName
                                ? Container(
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    color: Colors.red,
                                    margin: EdgeInsets.only(
                                        left: 0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                2.8,
                                        top: 2,
                                        bottom: 0),
                                  )
                                : Container(),
                            (widget.id.isEmpty || isEdit) && _isCompanyName
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    controller: _companyNameController,
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: textTheme.subhead.copyWith(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText: "Company Name",
                                      errorText: _errorText,
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                  )
                                : _companyNameController.text.isEmpty || isEdit
                                    ? Container()
                                    : Column(
                                        children: <Widget>[
//                                    Expanded(
//                                      flex: 5,
//                                      child: Text(
//                                        "Company Name",
//                                        textAlign: TextAlign.right,
//                                        style: textTheme.subtitle.copyWith(
//                                          fontWeight: FontWeight.w600,
//                                        ),
//                                      ),
//                                    ),
//                                    Expanded(
//                                      flex: 1,
//                                      child: Text(
//                                        " - ",
//                                        textAlign: TextAlign.center,
//                                      ),
//                                    ),
                                          Center(
                                            child: Text(
                                              _companyNameController.text,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          )
                                        ],
                                      ),
                            Padding(
                              padding: widget.id.isNotEmpty
                                  ? EdgeInsets.all(4)
                                  : EdgeInsets.all(6),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Text(
                                    "Relationship",
                                    textAlign: widget.id.isEmpty || isEdit
                                        ? TextAlign.left
                                        : TextAlign.center,
                                    style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: _relationshipController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(
                                      widget.id.isEmpty || isEdit ? 0 : 0),
                            ),
                            widget.id.isEmpty || isEdit
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
                              padding: _relationshipController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(0),
                            ),
                            _currentRelation || isEdit
                                ? _relationshipType == "Other"
                                    ? TextField(
                                        enabled: widget.id.isEmpty || isEdit,
                                        controller:
                                            _otherRelationshipController,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                          ),
                                          labelText: widget.id.isNotEmpty
                                              ? ""
                                              : "Other info here",
                                          errorText: _errorRelationship,
                                          border: widget.id.isEmpty || isEdit
                                              ? null
                                              : InputBorder.none,
                                        ),
                                        style: textTheme.subhead.copyWith(
                                          color: qDarkmodeEnable
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )
                                    : Container()
                                : widget.id.isEmpty || isEdit
                                    ? Container()
                                    : Column(
                                        children: <Widget>[
//                                    Expanded(
//                                      flex: 5,
//                                      child: Text(
//                                        "Relationship",
//                                        textAlign: TextAlign.right,
//                                        style: textTheme.subtitle.copyWith(
//                                          fontWeight: FontWeight.w600,
//                                        ),
//                                      ),
//                                    ),
//                                    Expanded(
//                                      flex: 1,
//                                      child: Text(
//                                        " - ",
//                                        textAlign: TextAlign.center,
//                                      ),
//                                    ),
                                          Center(
                                            child: Text(
                                              _relationshipController.text
                                                      .contains("Other")
                                                  ? _otherRelationshipController
                                                      .text
                                                  : _relationshipController
                                                      .text,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                            Padding(
                              padding: _textController.text.isEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    controller: _textController,
                                    keyboardType: TextInputType.number,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: textTheme.subhead.copyWith(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      // Fit the validating format.
                                      phoneNumberFormatter,
                                    ],
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText: "Mobile/Text",
                                      errorText: _errorText,
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                  )
                                : Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          "Mobile/Text",
                                          textAlign: TextAlign.right,
                                          style: textTheme.subtitle.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                      new Container(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              top: 0),
                                          alignment: Alignment.bottomCenter,
                                          child: Divider(
                                            color: qDarkmodeEnable
                                                ? Colors.white
                                                : Colors.black,
                                            height: 5,
                                            thickness: 1.5,
                                          )),
                                      Center(
                                          child: InkWell(
                                        onTap: () async {
                                          String phone =
                                              'tel:+1${_textController.text}';
                                          _callPhone(phone);
                                          //await CallNumber().callNumber(_textController.text);
                                        },
                                        child: Text(
                                          _textController.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ))
                                    ],
                                  ),
                            Padding(
                              padding: _phoneController.text.isEmpty
                                  ? EdgeInsets.all(2)
                                  : EdgeInsets.all(4),
                            ),
                            Padding(
                              padding: widget.id.isEmpty
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(0),
                            ),
                            ShowUp(
                              child: !_isphoneNumber
                                  ? new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isphoneNumber = true;
                                        });
                                      },
                                      child: widget.id.isEmpty || isEdit
                                          ? Text(
                                              "Click here to add a phone#",
                                              style: textTheme.display1
                                                  .copyWith(
                                                      color: Colors.red,
                                                      fontSize: 16),
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              delay: 1000,
                            ),
                            widget.id.isEmpty && !_isphoneNumber
                                ? Container(
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    color: Colors.red,
                                    margin: EdgeInsets.only(
                                        left: 0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        top: 2,
                                        bottom: 0),
                                  )
                                : Container(),
                            (widget.id.isEmpty || isEdit) && _isphoneNumber
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: textTheme.subhead.copyWith(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      // Fit the validating format.
                                      phoneNumberFormatter,
                                    ],
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText: "Phone",
                                      errorText: _errorPhone,
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                  )
                                : _phoneController.text.isEmpty || isEdit
                                    ? Container()
                                    : Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Phone",
                                              textAlign: TextAlign.right,
                                              style: textTheme.subtitle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                            ),
                                          ),
                                          new Container(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  top: 0),
                                              alignment: Alignment.bottomCenter,
                                              child: Divider(
                                                color: qDarkmodeEnable
                                                    ? Colors.white
                                                    : Colors.black,
                                                height: 5,
                                                thickness: 1.5,
                                              )),
                                          Center(
                                              child: InkWell(
                                            onTap: () {
                                              String phone =
                                                  'tel:+1${_phoneController.text}';
                                              _callPhone(phone);
                                            },
                                            child: Text(
                                              _phoneController.text,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ))
                                        ],
                                      ),
                            Padding(
                              padding: _isphoneNumber
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: textTheme.subhead.copyWith(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText: "Email",
                                      errorText: _errorEmail,
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                  )
                                : _emailController.text.isNotEmpty
                                    ? Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Email",
                                              textAlign: TextAlign.right,
                                              style: textTheme.subtitle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                            ),
                                          ),
                                          new Container(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  top: 0),
                                              alignment: Alignment.bottomCenter,
                                              child: Divider(
                                                color: qDarkmodeEnable
                                                    ? Colors.white
                                                    : Colors.black,
                                                height: 5,
                                                thickness: 1.5,
                                              )),
                                          Center(
                                              child: InkWell(
                                            onTap: () {
                                              String email =
                                                  "mailto:${_emailController.text}";
                                              _callPhone(email);
                                            },
                                            child: Text(
                                              _emailController.text,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ))
                                        ],
                                      )
                                    : Container(),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    controller: _notesController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: textTheme.subhead.copyWith(
                                      color: qDarkmodeEnable
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      labelText: "Notes",
                                      errorText: _errorEmail,
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                  )
                                : _notesController.text.isNotEmpty
                                    ? Column(
                                        children: <Widget>[
                                          Text(
                                            "Notes",
                                            textAlign: TextAlign.right,
                                            style: textTheme.subtitle.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          ),
                                          new Container(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  top: 0),
                                              alignment: Alignment.bottomCenter,
                                              child: Divider(
                                                color: qDarkmodeEnable
                                                    ? Colors.white
                                                    : Colors.black,
                                                height: 5,
                                                thickness: 1.5,
                                              )),
                                          Text(
                                            _notesController.text,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )
                                    : Container(),
                            Padding(
                              padding: widget.id.isNotEmpty
                                  ? EdgeInsets.all(9)
                                  : EdgeInsets.all(5),
                            ),
                            widget.id.isNotEmpty && !isEdit
                                ? Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Click to see',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                    ],
                                  )
                                : Container(),
                            widget.id.isNotEmpty && !isEdit
                                ? Container(
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    color: Colors.red,
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                3.0,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                3.0,
                                        top: 2,
                                        bottom: 0),
                                  )
                                : Container(),
                            Padding(padding: EdgeInsets.all(5)),
                            ShowUp(
                              child: widget.id.isEmpty || isEdit
                                  ? Container()
                                  : new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isdateToRemmber = true;
                                        });
                                      },
                                      child: Text(
                                        "Dates to Remember",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )),
                              delay: 1000,
                            ),
                            Row(
                              children: <Widget>[
                                widget.id.isEmpty || isEdit
                                    ? Expanded(
                                        child: Text(
                                        "Dates to Remember",
                                        style: textTheme.subhead.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ))
                                    : Container(),
                                widget.id.isEmpty || isEdit
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
                              padding: EdgeInsets.all(
                                  widget.id.isEmpty || isEdit ? 5 : 0),
                            ),
                            ListView.builder(
                              itemCount: _dateToRememberItems.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                DateToRememberData data =
                                    _dateToRememberItems[index];
                                final _dateToRememberController =
                                    TextEditingController();
                                final _dateToRememberDateController =
                                    TextEditingController();
                                final _yearController = TextEditingController();
                                _dateToRememberController.addListener(() {
                                  data.type = _dateToRememberController.text;
                                  _dateToRememberItems[index] = data;
                                });
                                void _handleDateToRememberValueChange(
                                    String value) {
                                  setState(() {
                                    data.type = value;
                                    _dateToRememberItems[index] = data;
                                  });
                                }

                                _dateToRememberController.text = data.type;

                                _dateToRememberDateController.text =
                                    data.date != null
                                        ? formatDate(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data.date ?? 0),
                                            [
                                                mm,
                                                '-',
                                                dd,
                                              ])
                                        : "";
                                _yearController.text =
                                    data.year != null ? data.year : "";
                                return widget.id.isEmpty || isEdit
                                    ? Column(
                                        crossAxisAlignment:
                                            widget.id.isEmpty || isEdit
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.center,
                                        children: <Widget>[
                                          widget.id.isEmpty || isEdit
                                              ? DropdownButton<String>(
                                                  items: dateToRemember
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
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
                                                  enabled: widget.id.isEmpty ||
                                                      isEdit,
                                                  controller:
                                                      _dateToRememberController,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  decoration: InputDecoration(
                                                    labelStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          202, 208, 215, 1.0),
                                                    ),
                                                    labelText:
                                                        widget.id.isNotEmpty
                                                            ? ""
                                                            : "Other Info here",
                                                    border: widget.id.isEmpty ||
                                                            isEdit
                                                        ? null
                                                        : InputBorder.none,
                                                  ),
                                                  style: textTheme.subhead
                                                      .copyWith(
                                                    color: qDarkmodeEnable
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                )
                                              : Container(),
                                          widget.id.isEmpty || isEdit
                                              ? Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          final DateTime picked =
                                                              await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime(
                                                                          2015,
                                                                          8),
                                                                  lastDate:
                                                                      DateTime(
                                                                          2101));
                                                          if (picked != null)
                                                            setState(() {
                                                              data.date = picked
                                                                  .millisecondsSinceEpoch;
                                                              _dateToRememberDateController
                                                                      .text =
                                                                  formatDate(
                                                                      picked, [
                                                                mm,
                                                                '-',
                                                                dd,
                                                              ]);
                                                              _dateToRememberItems[
                                                                  index] = data;
                                                            });
                                                        },
                                                        child: AbsorbPointer(
                                                          child: TextField(
                                                            enabled: widget.id
                                                                    .isEmpty ||
                                                                isEdit,
                                                            controller:
                                                                _dateToRememberDateController,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .sentences,
                                                            decoration:
                                                                InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        202,
                                                                        208,
                                                                        215,
                                                                        1.0),
                                                              ),
                                                              labelText: widget
                                                                          .id
                                                                          .isEmpty ||
                                                                      isEdit
                                                                  ? "Date"
                                                                  : "",
                                                              border: widget.id
                                                                          .isEmpty ||
                                                                      isEdit
                                                                  ? null
                                                                  : InputBorder
                                                                      .none,
                                                            ),
                                                            style: textTheme
                                                                .subhead
                                                                .copyWith(
                                                              color:
                                                                  qDarkmodeEnable
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      flex: 3,
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10)),
                                                    Expanded(
                                                      child: TextField(
                                                        enabled: true,
                                                        controller:
                                                            _yearController,
                                                        style: textTheme.subhead
                                                            .copyWith(
                                                                color: qDarkmodeEnable
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                        decoration:
                                                            InputDecoration(
                                                          labelStyle: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    202,
                                                                    208,
                                                                    215,
                                                                    1.0),
                                                          ),
                                                          labelText: widget.id
                                                                      .isEmpty ||
                                                                  isEdit
                                                              ? "Year(Optional)"
                                                              : "",
                                                          border: widget.id
                                                                      .isEmpty ||
                                                                  isEdit
                                                              ? null
                                                              : InputBorder
                                                                  .none,
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (text) {
                                                          data.year = text;
                                                          _dateToRememberItems[
                                                              index] = data;
                                                        },
                                                      ),
                                                      flex: 2,
                                                    )
                                                  ],
                                                )
                                              : Text(
                                                  _dateToRememberDateController
                                                      .text)
                                        ],
                                      )
                                    : _isdateToRemmber
                                        ? Container(
                                            margin: EdgeInsets.all(5),
                                            child: Column(
                                              children: <Widget>[
                                                Center(
                                                  child: Text(
                                                    data.type,
                                                    textAlign: TextAlign.right,
                                                    style: textTheme.subtitle
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                new Container(
                                                    padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                        top: 0),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Divider(
                                                      color: qDarkmodeEnable
                                                          ? Colors.white
                                                          : Colors.black,
                                                      height: 5,
                                                      thickness: 1.5,
                                                    )),
                                                Center(
                                                  child: _yearController
                                                          .text.isNotEmpty
                                                      ? Text(
                                                          _dateToRememberDateController
                                                                  .text +
                                                              "-" +
                                                              _yearController
                                                                  .text,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )
                                                      : Text(
                                                          _dateToRememberDateController
                                                              .text,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container();
                              },
                            ),
                            Padding(
                              padding: widget.id.isNotEmpty
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.all(4),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "${widget.id.isEmpty || isEdit ? 'Add Pictures' : ''}",
                                    style: textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                widget.id.isEmpty || isEdit
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
                              padding: widget.id.isEmpty || isEdit
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.all(0),
                            ),
                            ShowUp(
                              child: widget.id.isEmpty || isEdit
                                  ? Container()
                                  : new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isclicktoLikes = true;
                                        });
                                      },
                                      child: _isclicktoLikes
                                          ? Text(
                                              "Likes",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            )
                                          : Text(
                                              "Likes",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            )),
                              delay: 1000,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : _isclicktoLikes
                                    ? ListView.builder(
                                        itemCount: selectedLikesMap.keys.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String key = selectedLikesMap.keys
                                              .elementAt(index);
                                          String value = selectedLikesMap[key];
                                          return value.isNotEmpty
                                              ? Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        key,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: textTheme
                                                            .subtitle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        " - ",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        value,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      flex: 5,
                                                    )
                                                  ],
                                                )
                                              : Container();
                                        },
                                      )
                                    : Container(),
                            widget.id.isEmpty || isEdit
                                ? files.length > 0
                                    ? SizedBox(
                                        height: 90,
                                        child: ListView.builder(
                                          itemCount: files.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            File file = File(files[index]);
                                            return file.path.startsWith("https")
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    height: 80,
                                                    width: 150,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        widget.id.isNotEmpty ||
                                                                isEdit &&
                                                                    file.path
                                                                        .startsWith(
                                                                            "https")
                                                            ? Image.network(
                                                                file.path
                                                                        .toString() ??
                                                                    "",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.file(
                                                                file,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                        Positioned(
                                                          right: 14,
                                                          top: 0,
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                files =
                                                                    new List();
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container(
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
                                                                files =
                                                                    new List();
                                                              });
                                                            },
                                                            child: Container(
                                                              child: Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              color:
                                                                  Colors.black,
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
                                : Container(),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: widget.id.isEmpty || isEdit
                                      ? Text(
                                          "Likes",
                                          style: textTheme.subhead.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Container(),
                                ),
                                widget.id.isEmpty || isEdit
                                    ? _adddefaultlikes
                                        ? Container()
                                        : IconButton(
                                            icon: Icon(Icons.add_circle),
                                            onPressed: () {
                                              setState(() {
                                                _adddefaultlikes = true;
                                              });
                                              // _showDialog();
                                            },
                                          )
                                    : Container()
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(6),
                            ),
                            _adddefaultlikes || (isEdit || widget.id.isEmpty)
                                ? Wrap(
                                    children: items2,
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.all(2),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Column(
                                    children: likesTextFields,
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.all(4),
                            ),
                            widget.id.isNotEmpty && !isEdit
                                ? ShowUp(
                                    child: new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          subContact = SubContact();
                                        });
                                      },
                                      child: Text(
                                        "Click here to add contact notes",
                                        textAlign: TextAlign.center,
                                        style: textTheme.display1.copyWith(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ),
                                    delay: 1000,
                                  )
                                : Container(),
                            widget.id.isNotEmpty && !isEdit
                                ? Container(
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    color: Colors.red,
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                4.5,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                4.5,
                                        top: 2,
                                        bottom: 0),
                                  )
                                : Container(),
                            ListView.builder(
                              itemCount: subContacts.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                SubContact notesTodo = subContacts[index];
                                DateTime dateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        notesTodo.createdDate);
                                return ListTile(
                                  title: Text(notesTodo.title),
                                  leading: CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(3, 218, 157, 1.0),
                                      radius: 35,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${formatDate(dateTime, [dd])}",
                                                textAlign: TextAlign.center,
                                                style:
                                                    textTheme.headline.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                "${formatDate(dateTime, [M])}",
                                                textAlign: TextAlign.center,
                                                style:
                                                    textTheme.caption.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${formatDate(dateTime, [
                                                "/",
                                                yy
                                              ])}",
                                              textAlign: TextAlign.center,
                                              style: textTheme.caption.copyWith(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            ),
                            widget.id.isEmpty || isEdit
                                ? RaisedButton(
                                    color: Color.fromRGBO(3, 218, 157, 1.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      _submitContact();
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

  //added image cropper in the code
  Future<Null> _cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      image = croppedFile;
      setState(() {
        //_image = image;
        files.clear();
        files.add(image.path);
      });
    }
  }

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
                var image = await ImagePicker.pickImage(
                    source: ImageSource.camera, imageQuality: 50);
                _cropImage(image);
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                _cropImage(image);
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
      userId = data.user_id;
      files.clear();
      files.addAll(data.files);
      _dateToRememberItems.clear();
      _dateToRememberItems.addAll(data.dateToRemember);
      _nameController.text = data.name;
      // _dateToRememberController.text = data.dateToRemember;
      _emailController.text = data.email;
      _phoneController.text = data.phone;
      _relationshipController.text = data.relationship;
      _textController.text = data.text;
      _relationshipType = data.relationship;
      selectedLikesMap = data.likeadded;
      _otherRelationshipController.text = data.otherrelationship;
      _companyNameController.text = data.companyName;
      _notesController.text = data.notes;
      subContacts = data.subContacts;
      if (data.companyName.isNotEmpty) {
        setState(() {
          _isCompanyName = true;
        });
      }
      if (data.phone.isNotEmpty) {
        setState(() {
          _isphoneNumber = true;
        });
      }
      if (data.relationship == "Other") {
        setState(() {
          //  _currentRelation = true;
        });
      }
    });
  }

  @override
  void onUpdate() {
    setState(() {
      isEdit = !isEdit;
      _adddefaultlikes = false;
    });
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
            "Warning",
            textAlign: TextAlign.center,
          ),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                    color: qDarkmodeEnable ? Colors.white : Colors.black87),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(82, 149, 171, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
                _showDialogConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogConfirm() {
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
            "Warning",
            textAlign: TextAlign.center,
          ),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Yes"),
              textColor: qDarkmodeEnable ? Colors.white : Colors.black,
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  presenter.contactDelete(widget.id);
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      Screens.CONTACTLIST.toString() + "/////"));
                  //Navigator.of(context).pop();
                }
              },
            ),
            new RaisedButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(3, 218, 157, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitContact() {
    selectedLikesMap.forEach((key, value) => {
          if (value.isEmpty) {selectedLikesMap.remove(key)}
        });
    setState(() {
      String nm = _nameController.text;
      String rel = _relationshipController.text;
      String ph = _phoneController.text;
      String txt = _textController.text;
      String em = _emailController.text;
      String otherrelationShip = _otherRelationshipController.text;
      String companyName = _companyNameController.text;
      String notes = _notesController.text;
      _errorEmail = null;
      _errorName = null;
      _errorPhone = null;
      _errorRelationship = null;
      _errorText = null;
      if (nm.isEmpty) {
        _errorName = "Cannot be empty";
      } else {
        showLoading();
        Contacts contacts = new Contacts();
        contacts.name = nm;
        contacts.id = widget.id;
        contacts.bandId = widget.bandId;
        contacts.relationship = rel;
        contacts.email = em;
        contacts.phone = ph;
        contacts.text = txt;
        contacts.files = files;
        contacts.subContacts = subContacts;
        contacts.likeadded = selectedLikesMap;
        contacts.dateToRemember = _dateToRememberItems;
        contacts.otherrelationship = otherrelationShip;
        contacts.companyName = companyName;
        contacts.notes = notes;
        //contacts.likeadded= selectedLikesMap;
        presenter.addContact(contacts);
      }
    });
  }

  _callPhone(phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not Call Phone';
    }
  }
}

class DateToRememberData {
  String type = "Select";
  int date;
  String year;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map();
    data['type'] = type;
    data['date'] = date;
    data['year'] = year;
    return data;
  }

  DateToRememberData();

  DateToRememberData.fromJSON(item) {
    type = item['type'];
    date = item['date'];
    year = item['year'];
  }
}
