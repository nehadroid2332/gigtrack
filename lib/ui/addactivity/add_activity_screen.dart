import 'dart:async';
import 'dart:core';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/ui/addactivity/add_activity_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:google_places_picker/google_places_picker.dart';

class AddActivityScreen extends BaseScreen {
  final String id;
  final int type;
  final bool isParent;

  AddActivityScreen(AppListener appListener,
      {this.id, this.type = 0, this.isParent = false})
      : super(appListener, title: "");

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState
    extends BaseScreenState<AddActivityScreen, AddActivityPresenter>
    implements AddActivityContract {
  final _titleController = TextEditingController(),
      _dateController = TextEditingController(),
      _timeController = TextEditingController(),
      _descController = TextEditingController(),
      _taskController = TextEditingController(),
      _parkingController = TextEditingController(),
      _otherController = TextEditingController(),
      _locController = TextEditingController(),
      _startTimeController = TextEditingController(),
      _endTimeController = TextEditingController(),
      _taskCompletion = TextEditingController();
  final List<Band> bands = [];
  final List<User> members = [];

  String _titleError,
      _dateError,
      _descError,
      _locError,
      _taskError,
      _startTimeError,
      _endTimeError;

  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  bool isVisible = false, isEdit = false;

  String _dateTxt = "";

  bool isRecurring = false;

  Future<Null> _selectDate(BuildContext context, int type) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
        startDate = picked;
        _dateController.text = formatDate(startDate, [mm, '-', dd, '-', yy]);
        // !isVisible ? _showDialog() : "";
      });
  }

  void selectTime(bool isStart) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      DateTime dateTime = DateTime(startDate.year, startDate.month,
          startDate.day, picked.hour, picked.minute);
      if (isStart) {
        startTime = picked;
        _startTimeController.text =
            formatDate(dateTime, [hh, ':', nn, ' ', am]);
      } else {
        endTime = picked;
        _endTimeController.text = formatDate(dateTime, [hh, ':', nn, ' ', am]);
      }
    }
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
              color: Color.fromRGBO(22, 102, 237, 1.0),
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

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
        actions: <Widget>[
          widget.id.isEmpty || widget.isParent
              ? Container()
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                ),
          widget.id.isEmpty || widget.isParent
              ? Container()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDialogConfirm();
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
            color: Color.fromRGBO(32, 95, 139, 1.0),
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
                "${widget.id.isEmpty || isEdit ? isEdit ? "Edit" : "Add" : ""} ${widget.type == Activites.TYPE_ACTIVITY ? "Activity" : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE ? "Performance Schedule" : widget.type == Activites.TYPE_PRACTICE_SCHEDULE ? "Performance Schedule" : widget.type == Activites.TYPE_TASK ? widget.isParent ? "Add Sub Task" : "Task" : ""}",
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
                      Padding(
                        padding:
                            EdgeInsets.all(widget.id.isEmpty || isEdit ? 8 : 0),
                      ),
                      (widget.id.isEmpty || isEdit || widget.isParent)
                          ? TextField(
                              enabled: widget.id.isEmpty ||
                                  isEdit ||
                                  widget.isParent,
                              minLines: 1,
                              maxLines: 4,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty ||
                                        isEdit ||
                                        widget.isParent
                                    ? (widget.type == Activites.TYPE_TASK &&
                                            widget.isParent &&
                                            widget.id.isNotEmpty)
                                        ? "Describe Task?"
                                        : widget.type ==
                                                Activites
                                                    .TYPE_PERFORMANCE_SCHEDULE
                                            ? "Special Event Instructions"
                                            : (widget.type ==
                                                        Activites.TYPE_TASK) &&
                                                    (widget.id.isEmpty ||
                                                        widget.id.isNotEmpty)
                                                ? "What is the Task"
                                                : "Title"
                                    : "",
                                labelStyle: textTheme.headline.copyWith(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _titleError,
                                border: widget.id.isEmpty ||
                                        isEdit ||
                                        widget.isParent
                                    ? null
                                    : InputBorder.none,
                              ),
                              style:
                                  widget.id.isEmpty || isEdit || widget.isParent
                                      ? textTheme.subtitle.copyWith(
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
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                  widget.type ==
                                      Activites.TYPE_PRACTICE_SCHEDULE)
                          ? InkWell(
                              child: AbsorbPointer(
                                child: TextField(
                                  enabled: widget.id.isEmpty || isEdit,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    labelText: widget.id.isEmpty || isEdit
                                        ? widget.type ==
                                                Activites.TYPE_PRACTICE_SCHEDULE
                                            ? "Date"
                                            : "Start Date"
                                        : "",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
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
                          : (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE)
                              ? Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    _dateTxt,
                                    style: textTheme.subhead.copyWith(
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                      widget.type == Activites.TYPE_PRACTICE_SCHEDULE
                          ? Row(
                              children: <Widget>[
                                (widget.id.isEmpty || isEdit)
                                    ? Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            selectTime(true);
                                          },
                                          child: AbsorbPointer(
                                            child: TextField(
                                              enabled:
                                                  widget.id.isEmpty || isEdit,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                labelText:
                                                    widget.id.isEmpty || isEdit
                                                        ? "Start Time"
                                                        : "",
                                                labelStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      202, 208, 215, 1.0),
                                                ),
                                                errorText: _startTimeError,
                                                border:
                                                    widget.id.isEmpty || isEdit
                                                        ? null
                                                        : InputBorder.none,
                                              ),
                                              controller: _startTimeController,
                                              style: textTheme.subhead.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(_startTimeController.text),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                (widget.id.isEmpty || isEdit)
                                    ? Expanded(
                                        child: InkWell(
                                          child: AbsorbPointer(
                                            child: TextField(
                                              enabled:
                                                  widget.id.isEmpty || isEdit,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                labelText:
                                                    widget.id.isEmpty || isEdit
                                                        ? "End Time"
                                                        : "",
                                                labelStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      202, 208, 215, 1.0),
                                                ),
                                                errorText: _endTimeError,
                                                border:
                                                    widget.id.isEmpty || isEdit
                                                        ? null
                                                        : InputBorder.none,
                                              ),
                                              controller: _endTimeController,
                                              style: textTheme.subhead.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            selectTime(false);
                                          },
                                        ),
                                      )
                                    : Text(_endTimeController.text)
                              ],
                            )
                          : Container(),
                      widget.type == Activites.TYPE_PRACTICE_SCHEDULE
                          ? Row(
                              children: <Widget>[
                                Checkbox(
                                  onChanged: (bool value) {
                                    setState(() {
                                      isRecurring = value;
                                    });
                                  },
                                  value: isRecurring,
                                ),
                                Text("Recurring same day of week and time")
                              ],
                            )
                          : Container(),
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                  widget.type ==
                                      Activites.TYPE_PRACTICE_SCHEDULE)
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
                          : widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                  widget.type ==
                                      Activites.TYPE_PRACTICE_SCHEDULE
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            _locController.text,
                                            textAlign: TextAlign.center,
                                            style: textTheme.subhead.copyWith(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 14, bottom: 6),
                              child: Text(
                                widget.type == Activites.TYPE_TASK
                                    ? "Description"
                                    : "Notes",
                                style: textTheme.subhead.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      (widget.type == Activites.TYPE_TASK &&
                              widget.isParent &&
                              widget.id.isNotEmpty)
                          ? Container()
                          : (widget.id.isEmpty || isEdit || widget.isParent)
                              ? TextField(
                                  decoration: InputDecoration(
                                    labelText: widget.id.isEmpty ||
                                            isEdit ||
                                            widget.isParent
                                        ? widget.type == Activites.TYPE_TASK
                                            ? "Describe Task?"
                                            : "Notes"
                                        : "",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    errorText: _descError,
                                    border: widget.id.isEmpty ||
                                            isEdit ||
                                            widget.isParent
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  enabled: widget.id.isEmpty ||
                                      isEdit ||
                                      widget.isParent,
                                  minLines: 2,
                                  maxLines: 10,
                                  textCapitalization:
                                      TextCapitalization.sentences,
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
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                  widget.type ==
                                      Activites.TYPE_PRACTICE_SCHEDULE)
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Set-List"),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {},
                                )
                              ],
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 14),
                                  child: Text(
                                    (widget.type ==
                                                Activites
                                                    .TYPE_PERFORMANCE_SCHEDULE ||
                                            widget.id.isNotEmpty)
                                        ? "Wardrobe"
                                        : "Task",
                                    style: textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE)
                          ? TextField(
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty || isEdit
                                    ? widget.type ==
                                            Activites.TYPE_PERFORMANCE_SCHEDULE
                                        ? "Wardrobe"
                                        : "Task"
                                    : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _taskError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              enabled: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              controller: _taskController,
                            )
                          : widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE
                              ? Text(
                                  _taskController.text,
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 14),
                                  child: Text(
                                    (widget.type ==
                                                Activites
                                                    .TYPE_PERFORMANCE_SCHEDULE ||
                                            widget.id.isNotEmpty)
                                        ? "Parking"
                                        : "",
                                    style: textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type ==
                                  Activites.TYPE_PERFORMANCE_SCHEDULE)
                          ? TextField(
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty || isEdit
                                    ? widget.type ==
                                            Activites.TYPE_PERFORMANCE_SCHEDULE
                                        ? "Parking"
                                        : ""
                                    : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _taskError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              enabled: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              controller: _parkingController,
                            )
                          : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                              ? Text(
                                  _parkingController.text,
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 14),
                                  child: Text(
                                    (widget.type ==
                                                Activites
                                                    .TYPE_PERFORMANCE_SCHEDULE ||
                                            widget.id.isNotEmpty)
                                        ? "Other Instructions"
                                        : "",
                                    style: textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type ==
                                  Activites.TYPE_PERFORMANCE_SCHEDULE)
                          ? TextField(
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty || isEdit
                                    ? widget.type ==
                                            Activites.TYPE_PERFORMANCE_SCHEDULE
                                        ? "Other Instructions"
                                        : ""
                                    : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                errorText: _taskError,
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              enabled: true,
                              textCapitalization: TextCapitalization.sentences,
                              style: textTheme.subhead.copyWith(
                                color: Colors.black,
                              ),
                              controller: _otherController,
                            )
                          : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                              ? Text(
                                  _otherController.text,
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                      widget.type == Activites.TYPE_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : FlatButton(
                                  textColor: Color.fromRGBO(235, 84, 99, 1.0),
                                  child: Text("Click to add task notes"),
                                  onPressed: () async {
                                    await widget.appListener.router.navigateTo(
                                        context,
                                        Screens.ADDACTIVITY.toString() +
                                            "/${widget.type}/${widget.id}/${true}");
                                    getData();
                                  },
                                )
                          : Container(),
                      widget.type == Activites.TYPE_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : Text(
                                  "Date of Note - $_dateTxt",
                                  textAlign: TextAlign.center,
                                )
                          : Container(),
                      widget.type == Activites.TYPE_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : _taskCompletion.text.isEmpty
                                  ? FlatButton(
                                      textColor:
                                          Color.fromRGBO(235, 84, 99, 1.0),
                                      child: Text(
                                          "Click here when task is completed"),
                                      onPressed: () {
                                        // presenter.updateTaskCompleteDate(widget.id);
                                      },
                                    )
                                  : Text(
                                      "Date of Completion - " +
                                          _taskCompletion.text,
                                      textAlign: TextAlign.center,
                                    )
                          : Container(),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : ListView.builder(
                              itemCount: subActivities.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                Activites activity = subActivities[index];
                                DateTime dateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        activity.startDate);
                                return ListTile(
                                  title: Text(
                                    activity.title,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(239, 181, 77, 1.0),
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
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "${formatDate(dateTime, [M])}",
                                              textAlign: TextAlign.center,
                                              style: textTheme.caption.copyWith(
                                                color: Colors.black,
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
                                                color: Colors.black87),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? RaisedButton(
                              onPressed: () {
                                String title = _titleController.text;
                                String desc = _descController.text;
                                String loc = _locController.text;
                                String ward = _taskController.text;
                                String park = _parkingController.text;
                                String other = _otherController.text;
                                setState(() {
                                  _titleError = null;
                                  _descError = null;
                                  _locError = null;
                                  _dateError = null;
                                  if (title.isEmpty) {
                                    _titleError = "Cannot be Empty";
                                  } else if (loc.isEmpty &&
                                      widget.type == Activites.TYPE_ACTIVITY) {
                                    _locError = "Cannot be Empty";
                                  } else {
                                    DateTime dateTime, dateTime2;
                                    if (widget.type ==
                                        Activites.TYPE_PRACTICE_SCHEDULE) {
                                      dateTime = DateTime(
                                          startDate.year,
                                          startDate.month,
                                          startDate.day,
                                          startTime.hour,
                                          startTime.minute);
                                      dateTime2 = DateTime(
                                          startDate.year,
                                          startDate.month,
                                          startDate.day,
                                          endTime.hour,
                                          endTime.minute);
                                    }
                                    Activites activities = Activites(
                                      title: title,
                                      id: widget.id,
                                      description: desc,
                                      isRecurring: isRecurring,
                                      startDate: widget.type ==
                                              Activites.TYPE_PRACTICE_SCHEDULE
                                          ? dateTime?.millisecondsSinceEpoch ??
                                              0
                                          : startDate.millisecondsSinceEpoch,
                                      endDate: widget.type ==
                                              Activites.TYPE_PRACTICE_SCHEDULE
                                          ? dateTime2?.millisecondsSinceEpoch ??
                                              0
                                          : 0,
                                      location: loc,
                                      type: widget.type,
                                      parking: park,
                                      wardrobe: ward,
                                      other: other,
                                    );
                                    showLoading();
                                    presenter.addActivity(
                                        activities, widget.isParent);
                                  }
                                });
                              },
                              color: Color.fromRGBO(32, 95, 139, 1.0),
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
  void onSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Added Successfully");
    Timer timer = new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  void showMessage(String message) {
    hideLoading();
    super.showMessage(message);
  }

  List<Activites> subActivities = [];

  @override
  void getActivityDetails(Activites activities) {
    hideLoading();
    setState(() {
      if (activities.taskCompleteDate != null) {
        DateTime completionDate =
            DateTime.fromMillisecondsSinceEpoch(activities.taskCompleteDate);

        _taskCompletion.text =
            formatDate(completionDate, [mm, '-', dd, '-', yy]);
      }
      subActivities.clear();
      subActivities.addAll(activities.subActivities);
      _titleController.text = activities.title;
      _descController.text = activities.description;
      _taskController.text = activities.wardrobe;
      //_type = activities.action_type;
      startDate = DateTime.fromMillisecondsSinceEpoch(activities.startDate);
      _dateTxt = formatDate(startDate, [D, ', ', mm, '-', dd, '-', yy]);
      _dateController.text = formatDate(startDate, [mm, '-', dd, '-', yy]);
      _startTimeController.text = formatDate(startDate, [hh, ':', nn, ' ', am]);

      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(activities.endDate);
      _endTimeController.text = formatDate(dateTime, [hh, ':', nn, ' ', am]);

      _locController.text = activities.location;
      _parkingController.text = activities.parking;
      _otherController.text = activities.other;
      //      _timeController.text = "at ${formatDate(dateTime, [hh, ':', nn, am])}";
      members.clear();
      // members.addAll(activities.bandmates);
    });
  }

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
  void onUpdate() {
    hideLoading();
    showMessage("Updated Successfully");
    setState(() {
      isEdit = !isEdit;
    });
    getData();
  }

  @override
  void onSubSuccess() {
    hideLoading();
    showMessage("Sub Task Added Successfully");
    Navigator.of(context).pop();
  }

  void getData() {
    if (widget.id.isNotEmpty && !widget.isParent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getActivityDetails(widget.id);
      });
    }
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
              color: Color.fromRGBO(32, 95, 139, 1.0),
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  presenter.activityDelete(widget.id);
                  Navigator.of(context).popUntil(
                      ModalRoute.withName(Screens.ACTIVITIESLIST.toString()));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
