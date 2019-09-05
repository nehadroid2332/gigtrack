import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/ui/addactivity/add_activity_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:google_places_picker/google_places_picker.dart';

class AddActivityScreen extends BaseScreen {
  final String id;

  AddActivityScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState
    extends BaseScreenState<AddActivityScreen, AddActivityPresenter>
    implements AddActivityContract {
  final _titleController = TextEditingController(),
      _dateController = TextEditingController(),
      _dateEndController = TextEditingController(),
      _timeController = TextEditingController(),
      _timeEndController = TextEditingController(),
      _descController = TextEditingController(),
      _taskController = TextEditingController(),
      _travelController = TextEditingController(),
      _locController = TextEditingController();
  final List<Band> bands = [];
  final List<User> members = [];

  String _titleError,
      _dateError,
      _dateEndError,
      _timeError,
      _timeEndError,
      _descError,
      _locError,
      _taskError;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  DateTime startDate, endDate;
  bool isVisible = false, isEdit = false;

  int _userType = 0, _type = 0;

  Band selectedBand;

  String _dateTxt = "", _dateEndTxt = "";

  Future<Null> _selectDate(BuildContext context, int type) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        if (type == 1) {
          startDate = picked;
          _dateController.text =
              formatDate(selectedDate, [mm, '-', dd, '-', yy]);
          !isVisible ? _showDialog() : "";
        } else if (type == 2) {
          if (startDate == null) {
            showMessage("Please Select Start Date first");
            return;
          }
          if (selectedDate.isBefore(startDate)) {
            showMessage("Please select End Date before Start Date");
            return;
          }
          endDate = picked;
          _dateEndController.text =
              formatDate(selectedDate, [mm, '-', dd, '-', yy]);
        }
      });
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
            "Select EndDate",
            textAlign: TextAlign.center,
          ),
          content:
              new Text("Do you want to select end date for activity/schedule?"),
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
              color: Color.fromRGBO(235, 84, 99, 1.0),
              onPressed: () {
                setState(() {
                  isVisible = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _selectTime(BuildContext context, int type) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime)
      setState(() {
        if (type == 1) {
          selectedStartTime = picked;
          _timeController.text = (selectedStartTime.format(context));
        } else if (type == 2) {
          selectedEndTime = picked;
          _timeEndController.text = (selectedStartTime.format(context));
        }
      });
  }

  void _handleUserTypeValueChange(int value) {
    setState(() {
      _userType = value;
    });
  }

  void _handleTypeValueChange(int value) {
    setState(() {
      _type = value;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getActivityDetails(widget.id);
      });
    }
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(235, 84, 99, 1.0),
        actions: <Widget>[
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                )
        ],
      );

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(235, 84, 99, 1.0),
            height: height / 2.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 0,
          ),
          child: Column(
            children: <Widget>[
              Text(
                "${widget.id.isEmpty || isEdit ? isEdit ? "Edit" : "Add" : ""} Activities/Schedule",
                style: textTheme.display1
                    .copyWith(color: Colors.white, fontSize: 30),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(
                child: Card(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      widget.id.isEmpty || isEdit
                          ? Text(
                              "Select one from each row:",
                              style: textTheme.headline.copyWith(
                                  color: widget.appListener.primaryColorDark),
                            )
                          : Container(),
                      Padding(
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 6 : 0),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Row(
                              children: <Widget>[
//                                InkWell(
//                                  onTap: widget.id.isEmpty || isEdit
//                                      ? () {
//                                          _handleUserTypeValueChange(0);
//                                        }
//                                      : null,
//                                  child: Container(
//                                    padding: EdgeInsets.symmetric(
//                                        horizontal: 14, vertical: 5),
//                                    decoration: BoxDecoration(
//                                        color: _userType == 0
//                                            ? Color.fromRGBO(209, 244, 236, 1.0)
//                                            : Color.fromRGBO(
//                                                244, 246, 248, 1.0),
//                                        borderRadius: BorderRadius.circular(15),
//                                        border: Border.all(
//                                            color: _userType == 0
//                                                ? Color.fromRGBO(
//                                                    70, 206, 172, 1.0)
//                                                : Color.fromRGBO(
//                                                    244, 246, 248, 1.0))),
//                                    child: Text(
//                                      'Personal',
//                                      style: new TextStyle(
//                                        fontSize: 16.0,
//                                        color: _userType == 0
//                                            ? Color.fromRGBO(70, 206, 172, 1.0)
//                                            : Color.fromRGBO(
//                                                202, 208, 215, 1.0),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                Padding(
//                                  padding: EdgeInsets.all(8),
//                                ),
//                                InkWell(
//                                  onTap: widget.id.isEmpty || isEdit
//                                      ? () {
//                                          presenter.getBands();
//                                          _handleUserTypeValueChange(1);
//                                        }
//                                      : null,
//                                  child: Container(
//                                    padding: EdgeInsets.symmetric(
//                                        horizontal: 14, vertical: 5),
//                                    decoration: BoxDecoration(
//                                        color: _userType == 1
//                                            ? Color.fromRGBO(209, 244, 236, 1.0)
//                                            : Color.fromRGBO(
//                                                244, 246, 248, 1.0),
//                                        borderRadius: BorderRadius.circular(15),
//                                        border: Border.all(
//                                            color: _userType == 1
//                                                ? Color.fromRGBO(
//                                                    70, 206, 172, 1.0)
//                                                : Color.fromRGBO(
//                                                    244, 246, 248, 1.0))),
//                                    child: Text(
//                                      'Band',
//                                      style: new TextStyle(
//                                        fontSize: 16.0,
//                                        color: _userType == 1
//                                            ? Color.fromRGBO(70, 206, 172, 1.0)
//                                            : Color.fromRGBO(
//                                                202, 208, 215, 1.0),
//                                      ),
//                                    ),
//                                  ),
//                                ),
                              ],
                            )
                          : Container(),
                      Padding(
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 8 : 0),
                      ),
                      (_userType == 1 && (widget.id.isEmpty || isEdit))
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButton<Band>(
                                items: bands.map((Band value) {
                                  return new DropdownMenuItem<Band>(
                                    value: value,
                                    child: new Text(value.name),
                                  );
                                }).toList(),
                                isExpanded: true,
                                onChanged: (b) {
                                  setState(() {
                                    selectedBand = b;
                                  });
                                },
                                value: selectedBand,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 8 : 0),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Wrap(
                              runSpacing: 14,
                              children: <Widget>[
                                InkWell(
                                  onTap: widget.id.isEmpty || isEdit
                                      ? () {
                                          _handleTypeValueChange(0);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _type == 0
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _type == 0
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Schedule',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _type == 0
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
                                            : Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                ),
                                InkWell(
                                  onTap: widget.id.isEmpty || isEdit
                                      ? () {
                                          _handleTypeValueChange(1);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _type == 1
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _type == 1
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Activity',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _type == 1
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
                                            : Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                ),
                                InkWell(
                                  onTap: widget.id.isEmpty || isEdit
                                      ? () {
                                          _handleTypeValueChange(2);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: _type == 2
                                            ? Color.fromRGBO(209, 244, 236, 1.0)
                                            : Color.fromRGBO(
                                                244, 246, 248, 1.0),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: _type == 2
                                                ? Color.fromRGBO(
                                                    70, 206, 172, 1.0)
                                                : Color.fromRGBO(
                                                    244, 246, 248, 1.0))),
                                    child: Text(
                                      'Task',
                                      style: new TextStyle(
                                        fontSize: 16.0,
                                        color: _type == 2
                                            ? Color.fromRGBO(70, 206, 172, 1.0)
                                            : Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      (widget.id.isEmpty || isEdit)
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              minLines: 1,
                              maxLines: 4,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText:
                                    widget.id.isEmpty || isEdit ? "Title" : "",
                                labelStyle: textTheme.headline.copyWith(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _titleError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              style: widget.id.isEmpty || isEdit
                                  ? textTheme.subhead.copyWith(
                                      color: Colors.black,
                                    )
                                  : textTheme.display1.copyWith(
                                      color: Colors.black,
                                    ),
                              controller: _titleController,
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                _titleController.text,
                                style: textTheme.display1.copyWith(
                                    color: Colors.black, fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      Row(
                        children: <Widget>[
                          widget.id.isEmpty || isEdit
                              ? Container()
                              : Container(),
//                          Align(
//                                  alignment: Alignment.center,
//                                  child: Icon(
//                                    Icons.calendar_today,
//                                    color: Colors.grey,
//                                  ),
//                                ),
                          Expanded(
                            child: widget.id.isEmpty || isEdit
                                ? InkWell(
                                    child: AbsorbPointer(
                                      child: TextField(
                                        enabled: widget.id.isEmpty || isEdit,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          labelText: widget.id.isEmpty || isEdit
                                              ? "Start Date"
                                              : "",
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                          ),
                                          errorText: _dateError,
                                          border: widget.id.isEmpty || isEdit
                                              ? null
                                              : InputBorder.none,
                                        ),
                                        controller: _dateController,
                                        style: textTheme.subhead.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      if (widget.id.isEmpty || isEdit)
                                        _selectDate(context, 1);
                                    },
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      _dateTxt,
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          widget.id.isEmpty || isEdit
                              ? Expanded(
                                  child: InkWell(
                                    child: AbsorbPointer(
                                      child: TextField(
                                        enabled: widget.id.isEmpty || isEdit,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          labelText: widget.id.isEmpty || isEdit
                                              ? "Start Time"
                                              : "",
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                          ),
                                          errorText: _timeError,
                                          border: widget.id.isEmpty || isEdit
                                              ? null
                                              : InputBorder.none,
                                        ),
                                        controller: _timeController,
                                        style: textTheme.subhead.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      if (widget.id.isEmpty || isEdit)
                                        _selectTime(context, 1);
                                    },
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      isVisible || widget.id.isNotEmpty
                          ? Row(
                              children: <Widget>[
                                widget.id.isEmpty || isEdit
                                    ? Container()
                                    : Container(),
                                Expanded(
                                  child: widget.id.isEmpty || isEdit
                                      ? InkWell(
                                          child: AbsorbPointer(
                                            child: TextField(
                                              enabled:
                                                  widget.id.isEmpty || isEdit,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                labelText:
                                                    widget.id.isEmpty || isEdit
                                                        ? "End Date"
                                                        : "",
                                                labelStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      202, 208, 215, 1.0),
                                                ),
                                                errorText: _dateEndError,
                                                border:
                                                    widget.id.isEmpty || isEdit
                                                        ? null
                                                        : InputBorder.none,
                                              ),
                                              controller: _dateEndController,
                                              style: textTheme.subhead.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            if (widget.id.isEmpty || isEdit)
                                              _selectDate(context, 2);
                                          },
                                        )
                                      : _dateEndTxt != 0.toString()
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: _dateEndTxt !=
                                                          0.toString()
                                                      ? 5
                                                      : 0,
                                                  top: _dateEndTxt !=
                                                          0.toString()
                                                      ? 5
                                                      : 0),
                                              child: Text(
                                                _dateEndTxt != 0.toString()
                                                    ? "to " + _dateEndTxt
                                                    : '',
                                                style:
                                                    textTheme.subhead.copyWith(
                                                  color: Colors.grey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : Container(),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                ),
                                widget.id.isEmpty || isEdit
                                    ? Expanded(
                                        child: InkWell(
                                          child: AbsorbPointer(
                                            child: TextField(
                                              enabled:
                                                  widget.id.isEmpty || isEdit,
                                              decoration: InputDecoration(
                                                labelText:
                                                    widget.id.isEmpty || isEdit
                                                        ? "End Time"
                                                        : "",
                                                labelStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      202, 208, 215, 1.0),
                                                ),
                                                errorText: _timeEndError,
                                                border:
                                                    widget.id.isEmpty || isEdit
                                                        ? null
                                                        : InputBorder.none,
                                              ),
                                              controller: _timeEndController,
                                              style: textTheme.subhead.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            if (widget.id.isEmpty || isEdit)
                                              _selectTime(context, 2);
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit
                          ? InkWell(
                              onTap: () async {
                                var place = await PluginGooglePlacePicker
                                    .showAutocomplete(
                                  mode: PlaceAutocompleteMode.MODE_OVERLAY,
                                  countryCode: "US",
                                  typeFilter: TypeFilter.ESTABLISHMENT,
                                );
                                _locController.text = place.address;
                              },
                              child: AbsorbPointer(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: widget.id.isEmpty || isEdit
                                        ? "Location"
                                        : "",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    errorText: _locError,
                                    border: widget.id.isEmpty || isEdit
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  enabled: widget.id.isEmpty || isEdit,
                                  controller: _locController,
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      _locController.text,
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 14, bottom: 6),
                              child: Text(
                                "Notes",
                                style: textTheme.subhead.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              decoration: InputDecoration(
                                labelText:
                                    widget.id.isEmpty || isEdit ? "Notes" : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _descError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              enabled: widget.id.isEmpty || isEdit,
                              minLines: 2,
                              maxLines: 10,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              controller: _descController,
                            )
                          : Text(
                              _descController.text,
                              textAlign: TextAlign.center,
                              style: textTheme.subtitle,
                            ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: Text(
                                "Task",
                                style: textTheme.subhead.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              decoration: InputDecoration(
                                labelText:
                                    widget.id.isEmpty || isEdit ? "Task" : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _taskError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              enabled: false,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              controller: _taskController,
                            )
                          : Text(
                              _taskController.text,
                              textAlign: TextAlign.center,
                            ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 14),
                              child: Text(
                                "Travel",
                                style: textTheme.subhead.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              decoration: InputDecoration(
                                labelText:
                                    widget.id.isEmpty || isEdit ? "Travel" : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _descError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              enabled: false,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              controller: _travelController,
                            )
                          : Text(
                              _travelController.text,
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      widget.id.isEmpty || isEdit
                          ? RaisedButton(
                              onPressed: () {
                                String title = _titleController.text;
                                String desc = _descController.text;
                                String loc = _locController.text;
                                String time = _timeController.text;
                                String date = _dateController.text;
                                String eDate = _dateEndController.text;
                                String eTime = _timeEndController.text;
                                setState(() {
                                  _titleError = null;
                                  _descError = null;
                                  _locError = null;
                                  _timeError = null;
                                  _dateError = null;
                                  _dateEndError = null;
                                  _timeEndError = null;
                                  if (title.isEmpty) {
                                    _titleError = "Cannot be Empty";
                                  } else if (loc.isEmpty) {
                                    _locError = "Cannot be Empty";
                                  } else if (time.isEmpty) {
                                    _timeError = "Cannot be Empty";
                                  } else if (date.isEmpty) {
                                    _dateError = "Cannot be Empty";
                                  }
//                                  else if (eTime.isEmpty) {
//                                    _timeEndError = "Cannot be Empty";
//                                  } else if (eDate.isEmpty) {
//                                    _dateEndError = "Cannot be Empty";
                                  //       }
                                  else {
                                    DateTime start = DateTime(
                                        startDate.year,
                                        startDate.month,
                                        startDate.day,
                                        selectedStartTime.hour,
                                        selectedStartTime.minute);
                                    DateTime end;
                                    if (endDate != null) {
                                      end = DateTime(
                                          endDate.year,
                                          endDate.month,
                                          endDate.day,
                                          selectedEndTime.hour,
                                          selectedEndTime.minute);
                                    }
                                    Activites activities = Activites(
                                      title: title,
                                      id: widget.id.isEmpty ? "" : widget.id,
                                      description: desc != null ? desc : "",
                                      startDate: start.millisecondsSinceEpoch,
                                      endDate: end != null
                                          ? end.millisecondsSinceEpoch
                                          : 0,
                                      location: loc,
                                      band_id: selectedBand?.id ?? "",
                                      type: _userType,
                                      action_type: _type,
                                    );
                                    showLoading();
                                    presenter.addActivity(activities);
                                  }
                                });
                              },
                              color: Color.fromRGBO(235, 84, 99, 1.0),
                              child: Text("Submit"),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : members.length == 0
                              ? Container()
                              : Text(
                                  "Members",
                                  style: textTheme.subtitle.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : ListView.builder(
                              itemCount: members.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                User user = members[index];
                                return ListTile(
                                  title: Text(
                                      "${user.firstName} ${user.lastName}"),
                                  subtitle: Text("${user.primaryInstrument}"),
                                  trailing: FlatButton(
                                    child: Text(
                                      "${user.status == "1" ? "Accepted" : user.status == "3" ? "Pending" + (user.id == presenter.getCurrentUserId() ? "me" : "") : ""}",
                                      style: textTheme.subtitle.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onPressed: user.status == "3" &&
                                            user.id ==
                                                presenter.getCurrentUserId()
                                        ? () {
                                            presenter
                                                .acceptStatusForBandMemberinAcitivty(
                                                    widget.id);
                                          }
                                        : null,
                                  ),
                                );
                              },
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
  AddActivityPresenter get presenter => AddActivityPresenter(this);

  @override
  void onSuccess(ActivitiesResponse res) {
    if (!mounted) return;
    hideLoading();
    showMessage(res.message);
    Timer timer = new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  void showMessage(String message) {
    hideLoading();
    super.showMessage(message);
  }

  @override
  void getBandSuccess(List<Band> bands) {
    if (!mounted) return;
    hideLoading();
    setState(() {
      this.bands.clear();
      this.bands.addAll(bands);
      if (band_id != null) {
        bands.forEach((b) {
          if (b.id == band_id) {
            selectedBand = b;
          }
        });
      }
    });
  }

  @override
  void getActivityDetails(Activites activities) {
    hideLoading();
    setState(() {
      _titleController.text = activities.title;
      _descController.text = activities.description;
      _userType = activities.type;
      _travelController.text = activities.travel;
      _taskController.text = activities.task;
      _type = activities.action_type;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(activities.startDate);
      _dateTxt = formatDate(dateTime, [D, ', ', mm, '-', dd, '-', yy]) +
          " at ${formatDate(dateTime, [hh, ':', nn, am])}";
      _dateController.text = formatDate(dateTime, [mm, '-', dd, '-', yy]);
      _timeController.text = formatDate(dateTime, [hh, ':', nn, ' ', am]);
      try {
        DateTime dateTime2 =
            DateTime.fromMillisecondsSinceEpoch(activities.endDate);
        _dateEndController.text = activities.endDate != 0
            ? formatDate(dateTime2, [mm, '-', dd, '-', yy])
            : "";
        _timeEndController.text = activities.endDate != 0
            ? formatDate(dateTime2, [hh, ':', nn, ' ', am])
            : "";
        _dateEndTxt = activities.endDate != 0
            ? formatDate(dateTime2, [D, ', ', mm, '-', dd, '-', yy])
            : 0;
        // " at ${formatDate(dateTime2, [hh, ':', nn, am])}";
      } catch (e) {
        _dateEndTxt = "0";
      }
      _locController.text = activities.location;
//      _timeController.text = "at ${formatDate(dateTime, [hh, ':', nn, am])}";
      members.clear();
      members.addAll(activities.bandmates);
      if (activities.band_id != null) {
        band_id = activities.band_id;
        presenter.getBands();
      }
    });
  }

  String band_id;

  @override
  void onActivitySuccess() {
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getActivityDetails(widget.id);
      });
    }
  }

  @override
  void onUpdate(ActivitiesResponse res) {
    hideLoading();
    showMessage("Updated Successfully");
    setState(() {
      isEdit = !isEdit;
    });
  }
}
