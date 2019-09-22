import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/ui/addcontact/add_contact_presenter.dart';
import 'package:gigtrack/utils/NumberTextInputFormatter.dart';
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
  NumberTextInputFormatter _phoneNumberFormatter= NumberTextInputFormatter(1);
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

  var files = <String>[];
  final _dateToRememberItems = <DateToRememberData>[];

  void _handleRelationshipValueChange(String value) {
    setState(() {
      _relationshipType = value;
      if (value == "Other") {
        _currentRelation = true;
        _otherRelationshipController.text=" ";
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
  bool isEdit = false;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor:  Color.fromRGBO(191,52,44, 1.0),
        actions: <Widget>[
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                      _adddefaultlikes=true;
                    });
                  },
                ),
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (id == null || id.isEmpty) {
                      showMessage("Id cannot be null");
                    } else {
                      _showDialogConfirm();
//                      presenter.contactDelete(id);
//                      Navigator.of(context).pop();
                    }
                  },
                )
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
                    :  Color.fromRGBO(191,52,44, 1.0)),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selectedLikesMap.containsKey(s)
                ?  Color.fromRGBO(191,52,44, 1.0)
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
              onChanged:(text){
                selectedLikesMap[key] = text;
                txtController.text= text.replaceAll(" ", ',');
              },


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
            color:  Color.fromRGBO(191,52,44, 1.0),
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
                "${widget.id.isEmpty ? "Add" : isEdit ? "Edit" : ""} Contact",
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
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : files.length > 0
                              ? SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    itemCount: files.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                              textCapitalization: TextCapitalization.words,
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Name",
                                errorText: _errorName,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            )
                          : Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Name",
                                    textAlign: TextAlign.right,
                                    style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " - ",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _nameController.text,
                                    textAlign: TextAlign.left,
                                  ),
                                  flex: 2,
                                )
                              ],
                            ),
                      Padding(
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 5 : 2),
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
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 5 : 0),
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
                        padding: EdgeInsets.all(3),
                      ),
                      _currentRelation || isEdit
                          ? _relationshipType=="Other"?TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _otherRelationshipController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: widget.id.isNotEmpty ? "" : "Other info here",
                                errorText: _errorRelationship,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                            ):Container()
                          : widget.id.isEmpty || isEdit
                              ? Container()
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Relationship",
                                        textAlign: TextAlign.right,
                                        style: textTheme.subtitle.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        " - ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _relationshipController.text=="Other"? _otherRelationshipController.text:_relationshipController.text,
                                        textAlign: TextAlign.left,
                                      ),
                                      flex: 2,
                                    )
                                  ],
                                ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              controller: _textController,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                                inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                // Fit the validating format.
                                _phoneNumberFormatter,
                                ],
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Mobile/Text",
                                errorText: _errorText,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                          : Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Mobile/Text",
                                    textAlign: TextAlign.right,
                                    style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " - ",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _textController.text,
                                    textAlign: TextAlign.left,
                                  ),
                                  flex: 2,
                                )
                              ],
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
                                child: widget.id.isEmpty || isEdit
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
                      (widget.id.isEmpty || isEdit) && _isphoneNumber
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
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
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                          : _phoneController.text.isEmpty || isEdit
                              ? Container()
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Phone",
                                        textAlign: TextAlign.right,
                                        style: textTheme.subtitle.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        " - ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _phoneController.text,
                                        textAlign: TextAlign.left,
                                      ),
                                      flex: 2,
                                    )
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
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                labelText: "Email",
                                errorText: _errorEmail,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                            )
                          : Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Email",
                                    textAlign: TextAlign.right,
                                    style: textTheme.subtitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " - ",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _emailController.text,
                                    textAlign: TextAlign.left,
                                  ),
                                  flex: 2,
                                )
                              ],
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        children: <Widget>[
                          widget.id.isEmpty || isEdit
                              ? Expanded(
                                  child: Text(
                                    "Dates to Remember",
                                    style: textTheme.subtitle
                                        .copyWith(fontWeight: FontWeight.bold),
                                    textAlign: widget.id.isEmpty || isEdit
                                        ? TextAlign.left
                                        : TextAlign.center,
                                  ),
                                )
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
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 5 : 0),
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
                          _dateToRememberDateController.text = data.date != null
                              ? formatDate(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data.date ?? 0),
                                  [mm, '-', dd, '-', yy])
                              : "";
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
                                            enabled:
                                                widget.id.isEmpty || isEdit,
                                            controller:
                                                _dateToRememberController,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    202, 208, 215, 1.0),
                                              ),
                                              labelText: widget.id.isNotEmpty
                                                  ? ""
                                                  : "Other Info here",
                                              border:
                                                  widget.id.isEmpty || isEdit
                                                      ? null
                                                      : InputBorder.none,
                                            ),
                                            style: textTheme.subhead.copyWith(
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
                                    widget.id.isEmpty || isEdit
                                        ? GestureDetector(
                                            onTap: () async {
                                              final DateTime picked =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate:
                                                          DateTime(2015, 8),
                                                      lastDate: DateTime(2101));
                                              if (picked != null)
                                                setState(() {
                                                  data.date = picked
                                                      .millisecondsSinceEpoch;
                                                  _dateToRememberDateController
                                                          .text =
                                                      formatDate(picked, [
                                                    mm,
                                                    '-',
                                                    dd,
                                                    '-',
                                                    yy
                                                  ]);
                                                  _dateToRememberItems[index] =
                                                      data;
                                                });
                                            },
                                            child: AbsorbPointer(
                                              child: TextField(
                                                enabled:
                                                    widget.id.isEmpty || isEdit,
                                                controller:
                                                    _dateToRememberDateController,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        202, 208, 215, 1.0),
                                                  ),
                                                  labelText:
                                                      widget.id.isEmpty ||
                                                              isEdit
                                                          ? "Date"
                                                          : "",
                                                  border: widget.id.isEmpty ||
                                                          isEdit
                                                      ? null
                                                      : InputBorder.none,
                                                ),
                                                style:
                                                    textTheme.subhead.copyWith(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _dateToRememberDateController.text)
                                  ],
                                )
                              : Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          data.type,
                                          textAlign: TextAlign.right,
                                          style: textTheme.subtitle.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          " - ",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _dateToRememberDateController.text,
                                          textAlign: TextAlign.left,
                                        ),
                                        flex: 2,
                                      )
                                    ],
                                  ),
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
                                child:_isclicktoLikes?Text(
                                  "Likes",
                                  style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ): Text(
                                  "Click to see likes",
                                  style: TextStyle(fontSize: 14),
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
                                    String key =
                                        selectedLikesMap.keys.elementAt(index);
                                    String value = selectedLikesMap[key];
                                    return Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            key,
                                            textAlign: TextAlign.right,
                                            style: textTheme.subtitle.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            " - ",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.left,
                                          ),
                                          flex: 2,
                                        )
                                      ],
                                    );
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          file,
                                                          fit: BoxFit.cover,
                                                        ),
                                                  Positioned(
                                                    right: 14,
                                                    top: 0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          files = new List();
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
                                                          files = new List();
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
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
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
                      _adddefaultlikes || isEdit
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
                      widget.id.isEmpty || isEdit
                          ? RaisedButton(
                              color: Color.fromRGBO(191,52,44, 1.0),
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
                                  String otherrelationShip= _otherRelationshipController.text;
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
                                    contacts.id = id;
                                    contacts.relationship = rel;
                                    contacts.email = em;
                                    contacts.phone = ph;
                                    contacts.text = txt;
                                    contacts.files = files;
                                    contacts.likeadded = selectedLikesMap;
                                    contacts.dateToRemember =
                                        _dateToRememberItems;
                                    contacts.otherrelationship= otherrelationShip;
                                    //contacts.likeadded= selectedLikesMap;
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
                  if (image != null) files.add(image.path);
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
                  if (image != null) files.add(image.path);
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

  String id;

  @override
  void getContactDetails(Contacts data) {
    hideLoading();
    setState(() {
      id = data.id;
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
      _otherRelationshipController.text= data.otherrelationship;
      if(data.relationship=="Other"){
        setState(() {
          _currentRelation=true;
        });
      }

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
              child: new Text("Yes"),
              textColor: Colors.white,
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
              color:  Color.fromRGBO(191,52,44, 1.0),
              onPressed: () {
                  if (id == null || id.isEmpty) {
                    showMessage("Id cannot be null");
                  } else {
                    presenter.contactDelete(id);
                    Navigator.of(context).popUntil(ModalRoute.withName(Screens.CONTACTLIST.toString()));
                    //Navigator.of(context).pop();
                  }



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
  int date;

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
