import 'dart:async';
import 'dart:core';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/ui/addactivity/add_activity_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';
import 'package:place_picker/place_picker.dart';

class AddActivityScreen extends BaseScreen {
  final String id;
  final int type;
  final bool isParent;
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  AddActivityScreen(
    AppListener appListener, {
    this.id,
    this.type = 0,
    this.isParent = false,
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "");

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState
    extends BaseScreenState<AddActivityScreen, AddActivityPresenter>
    implements AddActivityContract {
  final _titleController = TextEditingController(),
      _dateController = TextEditingController(),
      // _timeController = TextEditingController(),
      _endDateController = TextEditingController(),
      _descController = TextEditingController(),
      _taskController = TextEditingController(),
      _parkingController = TextEditingController(),
      _otherController = TextEditingController(),
      _locController = TextEditingController(),
      _startTimeController = TextEditingController(),
      _startEventTimeController = TextEditingController(),
      _endTimeController = TextEditingController(),
      _endEventTimeController = TextEditingController(),
      _completionDateController = TextEditingController(),
      _taskCompletion = TextEditingController();
  final List<Band> bands = [];
  final List<User> members = [];
  Band selectedBand;

  String _titleError,
      _dateError,
      _descError,
      _locError,
      _taskError,
      _startTimeError,
      _errorCompletionDate,
      _endTimeError;

  DateTime startDate = DateTime.now().toUtc();
  DateTime endDate = DateTime.now().toUtc();
  TimeOfDay startTime = TimeOfDay(hour: DateTime.now().hour, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: DateTime.now().hour, minute: 0);
  bool isVisible = false, isEdit = false;
  bool setTime = false;
  bool endDateShow = false;

  String _dateTxt = "", _estDateTxt = "", _dateEndTxt = "";

  bool isRecurring = false;

  bool hasCompletionDate = false;

  DateTime completionDate;

  BandMember selectedBandMember;

  String selectedBandId;

  String selectedBandMemberId;

  List<Travel> travelList = [];
  double longitude, latitude = 0;
  bool qDarkmodeEnable = false;

  String userId;

  Future<Null> _selectDate(BuildContext context, int type) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: type == 1 ? startDate : endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && (picked != startDate || picked != endDate))
      setState(() {
        if (type == 1) {
          startDate = picked;
          _dateController.text = formatDate(startDate, [mm, '-', dd, '-', yy]);
        } else if (type == 0) {
          endDate = picked;
          _endDateController.text = formatDate(endDate, [mm, '-', dd, '-', yy]);
        }
        // !isVisible ? _showDialog() : "";
      });
  }

  void selectTime(bool isStart, bool isEvent) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      DateTime dateTime = DateTime(startDate.year, startDate.month,
          startDate.day, picked.hour, picked.minute);
      if (isStart) {
        startTime = picked;
        if (isEvent) {
          _startEventTimeController.text =
              formatDate(dateTime, [h, ':', nn, ' ', am]);
        } else
          _startTimeController.text =
              formatDate(dateTime, [h, ':', nn, ' ', am]);
      } else {
        if (picked.hourOfPeriod <= startTime.hourOfPeriod) {
          showMessage("End Time must be later than Start Time");
        } else {
          endTime = picked;
          if (isEvent) {
            _endEventTimeController.text =
                formatDate(dateTime, [h, ':', nn, ' ', am]);
          } else
            _endTimeController.text =
                formatDate(dateTime, [h, ':', nn, ' ', am]);
        }
      }
    }
  }

  // user defined function
  // void _showDialog() {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.all(15),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //         title: new Text(
  //           "Select EndDate",
  //           textAlign: TextAlign.center,
  //         ),
  //         content:
  //             new Text("Do you want to select end date for activity/schedule?"),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text("No"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           new RaisedButton(
  //             child: new Text("Yes"),
  //             textColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(6)),
  //             color: Color.fromRGBO(22, 102, 237, 1.0),
  //             onPressed: () {
  //               setState(() {
  //                 isVisible = true;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    checkThemeMode();
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        actions: <Widget>[
          Container(
              alignment: Alignment.center,
              width: widget.id.isEmpty
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Text(
                  "${widget.id.isEmpty || isEdit ? isEdit ? "Edit" : "Add" : ""} ${widget.type == Activites.TYPE_ACTIVITY ? "Activity" : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE ? "Performance Schedule" : widget.type == Activites.TYPE_APPOINTMENT ? "Appointment" : widget.type == Activites.TYPE_PRACTICE_SCHEDULE ? "Practice Schedule" : widget.type == Activites.TYPE_TASK ? widget.isParent ? "Add Task Notes" : "Task" : widget.type == Activites.TYPE_BAND_TASK ? "Band Task" : ""}",
                  textAlign: TextAlign.center,
                  style: textTheme.headline.copyWith(
                    fontSize: widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                        ? 22
                        : 24,
                    color: Colors.white,
                  ),
                ),
              )),
          (widget.id.isEmpty || widget.isParent) &&
                  (widget.isLeader ||
                      userId == presenter.serverAPI.currentUserId)
              ? Container()
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                ),
          (widget.id.isEmpty || widget.isParent) &&
                  (widget.isLeader ||
                      userId == presenter.serverAPI.currentUserId)
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
    List<Widget> items = [];
    for (Band s in bands) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s.name,
            style: textTheme.subtitle.copyWith(
                color: selectedBand == s
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selectedBand == s
                ? Color.fromRGBO(124, 180, 97, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (selectedBand == null)
                    selectedBand = s;
                  else if (selectedBand == s) {
                    selectedBand = s;
                  } else
                    selectedBand = null;
                });
              }
            : null,
      ));
    }
    List<Widget> items2 = [];
    if (selectedBand != null) {
      for (BandMember s in selectedBand.bandmates.values) {
        items2.add(GestureDetector(
          child: Container(
            child: Text(
              "${s.firstName} ${s.lastName}",
              style: textTheme.subtitle.copyWith(
                  color: selectedBandMember == s
                      ? Colors.white
                      : widget.appListener.primaryColorDark),
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: selectedBandMember == s
                  ? Color.fromRGBO(124, 180, 97, 1.0)
                  : Color.fromRGBO(244, 246, 248, 1.0),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Color.fromRGBO(228, 232, 235, 1.0),
              ),
            ),
          ),
          onTap: widget.id.isEmpty || isEdit
              ? () {
                  setState(() {
                    if (selectedBandMember == null)
                      selectedBandMember = s;
                    else
                      selectedBandMember = null;
                  });
                }
              : null,
        ));
      }
    }

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 4.5),
          child: Container(
            color: Color.fromRGBO(40, 35, 188, 1.0),
            height: height / 4.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
              ),
              Expanded(
                child: Card(
                  child: ListView(
                    padding: EdgeInsets.all(10),
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
                                    ? ((widget.type == Activites.TYPE_TASK ||
                                                widget.type ==
                                                    Activites.TYPE_BAND_TASK) &&
                                            widget.isParent &&
                                            widget.id.isNotEmpty)
                                        ? "Add Note"
                                        : widget.type ==
                                                Activites
                                                    .TYPE_PERFORMANCE_SCHEDULE
                                            ? "Venue"
                                            : (widget.type ==
                                                            Activites
                                                                .TYPE_TASK ||
                                                        widget.type ==
                                                            Activites
                                                                .TYPE_BAND_TASK) &&
                                                    (widget.id.isEmpty ||
                                                        widget.id.isNotEmpty)
                                                ? "What is the Task"
                                                : widget.type ==
                                                        Activites.TYPE_ACTIVITY
                                                    ? "List Activity"
                                                    : widget.type ==
                                                            Activites
                                                                .TYPE_APPOINTMENT
                                                        ? "List Appointment"
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
                                          color: qDarkmodeEnable
                                              ? Colors.white
                                              : Colors.black,
                                        )
                                      : textTheme.display1.copyWith(
                                          color: qDarkmodeEnable
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                              controller: _titleController,
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                _titleController.text,
                                style: textTheme.display1.copyWith(
                                    color: qDarkmodeEnable
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                          ? (widget.id.isEmpty || isEdit) &&
                                  (widget.type == Activites.TYPE_ACTIVITY ||
                                      widget.type ==
                                          Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                      widget.type ==
                                          Activites.TYPE_PRACTICE_SCHEDULE)
                              ? TextField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        showPlacePicker();
//                                        var place =
//                                            await PluginGooglePlacePicker
//                                                .showAutocomplete(
//                                          mode: PlaceAutocompleteMode
//                                              .MODE_OVERLAY,
//                                          countryCode: "US",
//                                          typeFilter: TypeFilter.ESTABLISHMENT,
//                                        );
//                                        latitude = place.latitude;
//                                        longitude = place.longitude;
//                                        _locController.text =
//                                            (place.name + ',' + place.address);
                                      },
                                    ),
                                    labelText: widget.id.isEmpty || isEdit
                                        ? "Location (Click + for maps)"
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
                                    color: qDarkmodeEnable
                                        ? Colors.white
                                        : Colors.black,
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
                                      child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.grey,
                                              ),
                                              padding:
                                                  EdgeInsets.only(bottom: 4),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, top: 2),
                                                child: Text(
                                                  _locController.text,
                                                  textAlign: TextAlign.center,
                                                  style: textTheme.subhead
                                                      .copyWith(
                                                    fontSize: 15,
                                                    color: qDarkmodeEnable
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          widget.appListener.router.navigateTo(
                                              context,
                                              Screens.GOOGLEMAPS.toString() +
                                                  '/$latitude/$longitude');
                                        },
                                      ),
                                    )
                                  : Container()
                          : Container(),
                      Padding(
                        padding:
                            widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                                ? EdgeInsets.all(5)
                                : EdgeInsets.all(0),
                      ),
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type == Activites.TYPE_ACTIVITY ||
                                  widget.type == Activites.TYPE_APPOINTMENT ||
                                  widget.type ==
                                      Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                  widget.type ==
                                      Activites.TYPE_PRACTICE_SCHEDULE)
                          ? Container(
                              color: qDarkmodeEnable
                                  ? Colors.transparent
                                  : (widget.id.isEmpty || isEdit) &&
                                          (widget.type ==
                                                  Activites.TYPE_ACTIVITY ||
                                              widget.type ==
                                                  Activites.TYPE_APPOINTMENT ||
                                              widget.type ==
                                                  Activites
                                                      .TYPE_PERFORMANCE_SCHEDULE ||
                                              widget.type ==
                                                  Activites
                                                      .TYPE_PRACTICE_SCHEDULE)
                                      ? Colors.blue.shade50
                                      : Colors.transparent,
                              padding: EdgeInsets.all(8),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(Radius.circular(10)),
//                        border: Border(
//                          bottom: BorderSide(
//                            //                   <--- left side
//                            color: Colors.grey.shade200,
//                            width: 2.0,
//                          ),
//                          left: BorderSide(
//                            //                   <--- left side
//                            color:Colors.grey.shade200,
//                            width: 2.0,
//                          ),
//                          right: BorderSide(
//                            //                   <--- left side
//                            color:Colors.grey.shade200,
//                            width: 2.0,
//                          ),
//                          top: BorderSide(
//                            //                   <--- left side
//                            color: Colors.grey.shade200,
//                            width: 2.0,
//                          ),
//                        ),
//                      ),
                              child: Column(
                                children: <Widget>[
                                  (widget.id.isEmpty || isEdit) &&
                                          (widget.type ==
                                                  Activites.TYPE_ACTIVITY ||
                                              widget.type ==
                                                  Activites.TYPE_APPOINTMENT ||
                                              widget.type ==
                                                  Activites
                                                      .TYPE_PERFORMANCE_SCHEDULE ||
                                              widget.type ==
                                                  Activites
                                                      .TYPE_PRACTICE_SCHEDULE)
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: Column(
                                              children: <Widget>[
                                                Center(
                                                    child: Text(
                                                  "Start Date",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 3),
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    height: 30,
                                                    decoration: BoxDecoration(
//                                          color: Colors.lightBlue.shade100,
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 0.0,
                                                            color:
                                                                Colors.white),
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color: Colors
                                                                .grey.shade200),
                                                      ),
                                                    ),
                                                    child: AbsorbPointer(
                                                      child: TextField(
                                                        enabled:
                                                            widget.id.isEmpty ||
                                                                isEdit,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .sentences,
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        textAlign:
                                                            TextAlign.center,
                                                        decoration:
                                                            InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              EdgeInsets.all(8),
                                                          labelText: widget.id
                                                                      .isEmpty ||
                                                                  isEdit
                                                              ? widget.type ==
                                                                      Activites
                                                                          .TYPE_PRACTICE_SCHEDULE
                                                                  ? ""
                                                                  // : "Start Date"
                                                                  : ""
                                                              : "",
                                                          labelStyle: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    202,
                                                                    208,
                                                                    215,
                                                                    1.0),
                                                          ),
                                                          errorText: _dateError,
                                                          border: widget.id
                                                                      .isEmpty ||
                                                                  isEdit
                                                              ? null
                                                              : InputBorder
                                                                  .none,
                                                        ),
                                                        controller:
                                                            _dateController,
                                                        style: textTheme.subhead
                                                            .copyWith(
                                                          color: qDarkmodeEnable
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    if (widget.id.isEmpty ||
                                                        isEdit)
                                                      _selectDate(context, 1);
                                                  },
                                                )
                                              ],
                                            )),
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                            ),
                                            widget.type ==
                                                    Activites.TYPE_APPOINTMENT
                                                ? Container()
                                                : Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Center(
                                                            child: Text(
                                                          "End Date",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        )),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 3),
                                                        ),
                                                        InkWell(
                                                          child: Container(
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
//                                            color: Colors.lightBlue.shade100,
                                                              border: Border(
                                                                top: BorderSide(
                                                                    width: 0.0,
                                                                    color: Colors
                                                                        .white),
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200),
                                                              ),
                                                            ),
                                                            child:
                                                                AbsorbPointer(
                                                              child: TextField(
                                                                enabled: widget
                                                                        .id
                                                                        .isEmpty ||
                                                                    isEdit,
                                                                textCapitalization:
                                                                    TextCapitalization
                                                                        .sentences,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                decoration:
                                                                    InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  labelText: widget
                                                                              .id
                                                                              .isEmpty ||
                                                                          isEdit
                                                                      ? widget.type ==
                                                                              Activites.TYPE_PRACTICE_SCHEDULE
                                                                          ? ""
                                                                          // : "Start Date"
                                                                          : ""
                                                                      : "",
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            202,
                                                                            208,
                                                                            215,
                                                                            1.0),
                                                                  ),
                                                                  errorText:
                                                                      _dateError,
                                                                  border: widget
                                                                              .id
                                                                              .isEmpty ||
                                                                          isEdit
                                                                      ? null
                                                                      : InputBorder
                                                                          .none,
                                                                ),
                                                                controller:
                                                                    _endDateController,
                                                                style: textTheme
                                                                    .subhead
                                                                    .copyWith(
                                                                  color: qDarkmodeEnable
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (widget.id
                                                                    .isEmpty ||
                                                                isEdit)
                                                              _selectDate(
                                                                  context, 0);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        )
                                      : (widget.type ==
                                                  Activites.TYPE_ACTIVITY ||
                                              widget.type ==
                                                  Activites
                                                      .TYPE_PRACTICE_SCHEDULE ||
                                              widget.type ==
                                                  Activites
                                                      .TYPE_PERFORMANCE_SCHEDULE)
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      _dateTxt,
                                                      style: textTheme.subhead
                                                          .copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      _dateEndTxt,
                                                      style: textTheme.subhead
                                                          .copyWith(
                                                        color: Colors.grey,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container(),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
//                      widget.type == Activites.TYPE_ACTIVITY &&
//                              (widget.id.isEmpty || isEdit)
//                          ? ShowUp(
//                              child: !setTime
//                                  ? new GestureDetector(
//                                      onTap: () {
//                                        setState(() {
//                                          setTime = true;
//                                        });
//                                      },
//                                      child: Text(
//                                        "Click here to set time",
//                                        style: textTheme.display1.copyWith(
//                                            color: Colors.red, fontSize: 15),
//                                      ),
//                                    )
//                                  : Container(),
//                              delay: 1000,
//                            )
//                          : Container(),
                                  widget.type ==
                                              Activites
                                                  .TYPE_PERFORMANCE_SCHEDULE ||
                                          widget.type ==
                                              Activites.TYPE_ACTIVITY ||
                                          widget.type ==
                                              Activites
                                                  .TYPE_PRACTICE_SCHEDULE ||
                                          widget.type ==
                                              Activites.TYPE_APPOINTMENT
                                      ? (widget.type ==
                                                  Activites.TYPE_ACTIVITY &&
                                              setTime == true)
                                          ? Container()
                                          : Row(
                                              children: <Widget>[
                                                (widget.id.isEmpty || isEdit)
                                                    ? Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            selectTime(
                                                                true, false);
                                                          },
                                                          child: AbsorbPointer(
                                                              child: Column(
                                                            children: <Widget>[
                                                              Center(
                                                                  child: Text(
                                                                widget.type ==
                                                                            Activites
                                                                                .TYPE_APPOINTMENT ||
                                                                        widget.type ==
                                                                            Activites.TYPE_PRACTICE_SCHEDULE
                                                                    ? "Start Time"
                                                                    : "Setup Time",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              )),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            3),
                                                              ),
                                                              Container(
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
//                                                      color: Colors
//                                                          .lightBlue.shade100,
                                                                  border:
                                                                      Border(
                                                                    top: BorderSide(
                                                                        width:
                                                                            0.0,
                                                                        color: Colors
                                                                            .white),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200),
                                                                  ),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    TextField(
                                                                  enabled: widget
                                                                          .id
                                                                          .isEmpty ||
                                                                      isEdit,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    labelText:
                                                                        widget.id.isEmpty ||
                                                                                isEdit
                                                                            ? ""
                                                                            : "",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Color.fromRGBO(
                                                                          202,
                                                                          208,
                                                                          215,
                                                                          1.0),
                                                                    ),
                                                                    errorText:
                                                                        _startTimeError,
                                                                    border: widget.id.isEmpty ||
                                                                            isEdit
                                                                        ? null
                                                                        : InputBorder
                                                                            .none,
                                                                  ),
                                                                  controller:
                                                                      _startTimeController,
                                                                  style: textTheme
                                                                      .subhead
                                                                      .copyWith(
                                                                    color: qDarkmodeEnable
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                        ),
                                                      )
                                                    : _startTimeController
                                                            .text.isNotEmpty
                                                        ? Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              //"Start time -" +
                                                              _startTimeController
                                                                  .text
                                                                  .toLowerCase(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          )
                                                        : Container(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: (widget.id.isEmpty ||
                                                          isEdit)
                                                      ? Container()
                                                      : Text("to"),
                                                ),
                                                (widget.id.isEmpty || isEdit)
                                                    ? Expanded(
                                                        child: InkWell(
                                                          child: AbsorbPointer(
                                                              child: Column(
                                                            children: <Widget>[
                                                              Center(
                                                                  child: Text(
                                                                widget.type ==
                                                                            Activites
                                                                                .TYPE_APPOINTMENT ||
                                                                        widget.type ==
                                                                            Activites.TYPE_PRACTICE_SCHEDULE
                                                                    ? "End Time"
                                                                    : "Call Time",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              )),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            3),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
//                                                      color: Colors
//                                                          .lightBlue.shade100,
                                                                  border:
                                                                      Border(
                                                                    top: BorderSide(
                                                                        width:
                                                                            0.0,
                                                                        color: Colors
                                                                            .white),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200),
                                                                  ),
                                                                ),
                                                                height: 30,
                                                                child:
                                                                    TextField(
                                                                  enabled: widget
                                                                          .id
                                                                          .isEmpty ||
                                                                      isEdit,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    labelText:
                                                                        widget.id.isEmpty ||
                                                                                isEdit
                                                                            ? ""
                                                                            : "",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          22,
                                                                      color: Color.fromRGBO(
                                                                          202,
                                                                          208,
                                                                          215,
                                                                          1.0),
                                                                    ),
                                                                    errorText:
                                                                        _endTimeError,
                                                                    border: widget.id.isEmpty ||
                                                                            isEdit
                                                                        ? null
                                                                        : InputBorder
                                                                            .none,
                                                                  ),
                                                                  controller:
                                                                      _endTimeController,
                                                                  style: textTheme
                                                                      .subhead
                                                                      .copyWith(
                                                                    color: qDarkmodeEnable
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                          onTap: () {
                                                            selectTime(
                                                                false, false);
                                                          },
                                                        ),
                                                      )
                                                    : _endTimeController
                                                            .text.isNotEmpty
                                                        ? Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              // "End time - " +
                                                              _endTimeController
                                                                  .text
                                                                  .toLowerCase(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          )
                                                        : Container()
                                              ],
                                            )
                                      : Container(),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  widget.type ==
                                              Activites
                                                  .TYPE_PERFORMANCE_SCHEDULE ||
                                          widget.type == Activites.TYPE_ACTIVITY
                                      ? (widget.type ==
                                                  Activites.TYPE_ACTIVITY &&
                                              setTime == false)
                                          ? Container()
                                          : Row(
                                              children: <Widget>[
                                                (widget.id.isEmpty || isEdit)
                                                    ? Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            selectTime(
                                                                true, true);
                                                          },
                                                          child: AbsorbPointer(
                                                              child: Column(
                                                            children: <Widget>[
                                                              Center(
                                                                  child: Text(
                                                                "Event Start Time",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              )),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            3),
                                                              ),
                                                              Container(
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
//                                                      color: Colors
//                                                          .lightBlue.shade100,
                                                                  border:
                                                                      Border(
                                                                    top: BorderSide(
                                                                        width:
                                                                            0.0,
                                                                        color: Colors
                                                                            .white),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  ),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    TextField(
                                                                  enabled: widget
                                                                          .id
                                                                          .isEmpty ||
                                                                      isEdit,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    labelText:
                                                                        widget.id.isEmpty ||
                                                                                isEdit
                                                                            ? ""
                                                                            : "",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Color.fromRGBO(
                                                                          202,
                                                                          208,
                                                                          215,
                                                                          1.0),
                                                                    ),
                                                                    errorText:
                                                                        _startTimeError,
                                                                    border: widget.id.isEmpty ||
                                                                            isEdit
                                                                        ? null
                                                                        : InputBorder
                                                                            .none,
                                                                  ),
                                                                  controller:
                                                                      _startEventTimeController,
                                                                  style: textTheme
                                                                      .subhead
                                                                      .copyWith(
                                                                    color: qDarkmodeEnable
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                        ),
                                                      )
                                                    : _startEventTimeController
                                                            .text.isNotEmpty
                                                        ? Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              //"Start time -" +
                                                              _startEventTimeController
                                                                  .text
                                                                  .toLowerCase(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          )
                                                        : Container(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: (widget.id.isEmpty ||
                                                          isEdit)
                                                      ? Container()
                                                      : _endEventTimeController
                                                              .text.isNotEmpty
                                                          ? Text("to")
                                                          : Container(),
                                                ),
                                                (widget.id.isEmpty || isEdit)
                                                    ? Expanded(
                                                        child: InkWell(
                                                          child: AbsorbPointer(
                                                              child: Column(
                                                            children: <Widget>[
                                                              Center(
                                                                  child: Text(
                                                                "Event End Time",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              )),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            3),
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border:
                                                                      Border(
                                                                    top: BorderSide(
                                                                        width:
                                                                            0.0,
                                                                        color: Colors
                                                                            .white),
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  ),
                                                                ),
                                                                height: 30,
                                                                child:
                                                                    TextField(
                                                                  enabled: widget
                                                                          .id
                                                                          .isEmpty ||
                                                                      isEdit,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .center,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    labelText:
                                                                        widget.id.isEmpty ||
                                                                                isEdit
                                                                            ? ""
                                                                            : "",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          22,
                                                                      color: Color.fromRGBO(
                                                                          202,
                                                                          208,
                                                                          215,
                                                                          1.0),
                                                                    ),
                                                                    errorText:
                                                                        _endTimeError,
                                                                    border: widget.id.isEmpty ||
                                                                            isEdit
                                                                        ? null
                                                                        : InputBorder
                                                                            .none,
                                                                  ),
                                                                  controller:
                                                                      _endEventTimeController,
                                                                  style: textTheme
                                                                      .subhead
                                                                      .copyWith(
                                                                    color: qDarkmodeEnable
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                          onTap: () {
                                                            selectTime(
                                                                false, true);
                                                          },
                                                        ),
                                                      )
                                                    : _endEventTimeController
                                                            .text.isNotEmpty
                                                        ? Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              // "End time - " +
                                                              _endEventTimeController
                                                                  .text
                                                                  .toLowerCase(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          )
                                                        : Container()
                                              ],
                                            )
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),

                      Padding(
                        padding: EdgeInsets.all(0),
                      ),
//                      widget.type == Activites.TYPE_ACTIVITY &&
//                              (widget.id.isEmpty || isEdit)
//                          ? ShowUp(
//                              child: !endDateShow
//                                  ? new GestureDetector(
//                                      onTap: () {
//                                        setState(() {
//                                          endDateShow = true;
//                                        });
//                                      },
//                                      child: Text(
//                                        "Click here to add end date",
//                                        style: textTheme.display1.copyWith(
//                                            color: Colors.red, fontSize: 15),
//                                      ),
//                                    )
//                                  : Container(),
//                              delay: 1000,
//                            )
//                          : Container(),
                      endDateShow
                          ? ((widget.id.isEmpty || isEdit) &&
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
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        labelText: widget.id.isEmpty || isEdit
                                            ? widget.type ==
                                                    Activites
                                                        .TYPE_PRACTICE_SCHEDULE
                                                ? "Date"
                                                : "End Date"
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
                                      controller: _endDateController,
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    if (widget.id.isEmpty || isEdit)
                                      _selectDate(context, 0);
                                  },
                                )
                              : (widget.type == Activites.TYPE_ACTIVITY ||
                                      widget.type ==
                                          Activites.TYPE_PRACTICE_SCHEDULE)
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
                                  : Container())
                          : Container(),
                      widget.type == Activites.TYPE_PRACTICE_SCHEDULE
                          ? widget.id.isEmpty || isEdit
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
                                    Text(
                                      "Recurring same day and time",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                )
                              : Text(
                                  isRecurring
                                      ? "Recurring Practice ${_startTimeController.text} to ${_endTimeController.text}"
                                      : "Not Recurring",
                                  textAlign: TextAlign.center,
                                )
                          : Container(),
                      widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                          ? Container()
                          : (widget.id.isEmpty || isEdit) &&
                                  (widget.type == Activites.TYPE_ACTIVITY ||
                                      widget.type ==
                                          Activites.TYPE_APPOINTMENT ||
                                      widget.type ==
                                          Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                      widget.type ==
                                          Activites.TYPE_PRACTICE_SCHEDULE)
                              ? TextField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () async {
                                        showPlacePicker();
//                                        var place =
//                                            await PluginGooglePlacePicker
//                                                .showAutocomplete(
//                                          mode: PlaceAutocompleteMode
//                                              .MODE_OVERLAY,
//                                          countryCode: "US",
//                                          typeFilter: TypeFilter.ESTABLISHMENT,
//                                        );
//                                        latitude = place.latitude;
//                                        longitude = place.longitude;
//                                        _locController.text =
//                                            (place.name + ',' + place.address);
                                      },
                                    ),
                                    labelText: widget.id.isEmpty || isEdit
                                        ? "Location (Click + for maps)"
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
                                    color: qDarkmodeEnable
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )
                              : widget.type == Activites.TYPE_ACTIVITY ||
                                      widget.type ==
                                          Activites.TYPE_APPOINTMENT ||
                                      widget.type ==
                                          Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                      widget.type ==
                                          Activites.TYPE_PRACTICE_SCHEDULE
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  _locController.text,
                                                  textAlign: TextAlign.center,
                                                  style: textTheme.subhead
                                                      .copyWith(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () async {
                                          widget.appListener.router.navigateTo(
                                              context,
                                              Screens.GOOGLEMAPS.toString() +
                                                  '/$latitude/$longitude');
                                        },
                                      ),
                                    )
                                  : Container(),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(top: 14, bottom: 6),
                              child: Text(
                                widget.type == Activites.TYPE_TASK ||
                                        widget.type == Activites.TYPE_BAND_TASK
                                    ? "Description"
                                    : _descController.text.isEmpty
                                        ? ""
                                        : "Notes",
                                style: textTheme.subhead.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      (_descController.text.isNotEmpty && !isEdit)
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 3.3,
                                  right:
                                      MediaQuery.of(context).size.width / 3.3,
                                  bottom: 5,
                                  top: 0),
                              height: 2,
                              width: 60,
                              color: Colors.grey.shade300,
                            )
                          : Container(),
                      ((widget.type == Activites.TYPE_TASK ||
                                  widget.type == Activites.TYPE_BAND_TASK) &&
                              widget.isParent &&
                              widget.id.isNotEmpty)
                          ? Container()
                          : (widget.id.isEmpty || isEdit || widget.isParent)
                              ? TextField(
                                  decoration: InputDecoration(
                                    labelText: widget.id.isEmpty ||
                                            isEdit ||
                                            widget.isParent
                                        ? widget.type == Activites.TYPE_TASK ||
                                                widget.type ==
                                                    Activites.TYPE_BAND_TASK
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
                                    color: qDarkmodeEnable
                                        ? Colors.white
                                        : Colors.black,
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
                                        ? _taskController.text.isEmpty
                                            ? ""
                                            : "Wardrobe"
                                        : "Task",
                                    style: textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                      (_taskController.text.isNotEmpty && !isEdit)
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 3.3,
                                  right:
                                      MediaQuery.of(context).size.width / 3.3,
                                  bottom: 5,
                                  top: 5),
                              height: 2,
                              width: 60,
                              color: Colors.grey.shade300,
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
                                color: qDarkmodeEnable
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              controller: _taskController,
                            )
                          : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
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
                                        ? _parkingController.text.isEmpty
                                            ? ""
                                            : "Parking"
                                        : "",
                                    style: textTheme.subhead.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                      _parkingController.text.isNotEmpty && !isEdit
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 3.3,
                                  right:
                                      MediaQuery.of(context).size.width / 3.3,
                                  bottom: 5,
                                  top: 5),
                              height: 2,
                              width: 60,
                              color: Colors.grey.shade300,
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
                                color: qDarkmodeEnable
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              controller: _parkingController,
                            )
                          : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                              ? Text(
                                  _parkingController.text,
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                      (widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE)
                          ? Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Travel",
                                      textAlign: (widget.id.isEmpty || isEdit)
                                          ? TextAlign.left
                                          : TextAlign.center,
                                      style: textTheme.subhead.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  (widget.id.isEmpty || isEdit)
                                      ? IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () async {
                                            // showDialogConfirm();
                                            final travel = await widget
                                                .appListener.router
                                                .navigateTo(
                                                    context,
                                                    Screens.ADDTRAVEL
                                                            .toString() +
                                                        "/////////${widget.id}");
                                            print("Sd-> $travel");
                                            setState(() {
                                              if (travel != null &&
                                                  travel is Travel)
                                                travelList.add(travel);
                                            });
                                          },
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          : Container(),
                      (widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: travelList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Travel travel = travelList[index];
                                return ListTile(
                                  title: Text("${travel.location}"),
                                  subtitle: Text("${travel.notes}"),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        travelList.removeAt(index);
                                      });
                                    },
                                  ),
                                  onTap: () async {
                                    final tr = await widget.appListener.router
                                        .navigateTo(
                                            context,
                                            Screens.ADDTRAVEL.toString() +
                                                "//${travel.id}///////${widget.id}");
                                    setState(() {
                                      for (var i = 0;
                                          i < travelList.length;
                                          i++) {
                                        Travel travel1 = travelList[i];
                                        if (travel.id == tr.id &&
                                            travel1.id == travel.id) {
                                          travelList[i] = tr;
                                        }
                                      }
                                    });
                                  },
                                );
                              },
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
                                        ? _otherController.text.isEmpty
                                            ? ""
                                            : "Other Instructions"
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
                                color: qDarkmodeEnable
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              controller: _otherController,
                            )
                          : widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE
                              ? Text(
                                  _otherController.text,
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                      widget.type == Activites.TYPE_TASK ||
                              widget.type == Activites.TYPE_BAND_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : FlatButton(
                                  textColor: Color.fromRGBO(235, 84, 99, 1.0),
                                  child: Text("Click to add task notes"),
                                  onPressed: () async {
                                    await widget.appListener.router.navigateTo(
                                        context,
                                        Screens.ADDACTIVITY.toString() +
                                            "/${widget.type}/${widget.id}/${true}/////");
                                    getData();
                                  },
                                )
                          : Container(),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.red,
                              margin: EdgeInsets.only(
                                  left: 0,
                                  right:
                                      MediaQuery.of(context).size.width / 2.8,
                                  top: 2,
                                  bottom: 0),
                            ),
                      widget.type == Activites.TYPE_TASK ||
                              widget.type == Activites.TYPE_BAND_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Task Date - ",
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _dateTxt,
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(6),
                      ),
                      widget.type == Activites.TYPE_TASK ||
                              widget.type == Activites.TYPE_BAND_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : _estDateTxt.isEmpty
                                  ? Container()
                                  : Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Est. Completion Date - ",
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _estDateTxt,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: qDarkmodeEnable
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        )
                                      ],
                                    )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.type == Activites.TYPE_TASK ||
                              widget.type == Activites.TYPE_BAND_TASK
                          ? widget.id.isEmpty || isEdit || widget.isParent
                              ? Container()
                              : _taskCompletion.text.isEmpty
                                  ? FlatButton(
                                      textColor:
                                          Color.fromRGBO(235, 84, 99, 1.0),
                                      child: Text(
                                          "Click here if task is completed"),
                                      onPressed: () {
                                        isEdit = true;
                                        presenter
                                            .updateTaskCompleteDate(widget.id);
                                      },
                                    )
                                  : Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "Date Completed - ",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: qDarkmodeEnable
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                _taskCompletion.text,
                                                textAlign: TextAlign.left,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(2),
                                              ),
                                              InkWell(
                                                child: Icon(Icons.delete),
                                                onTap: () {
                                                  presenter.removeDateCompleted(
                                                      widget.id);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      (widget.id.isEmpty || isEdit) &&
                              (widget.type == Activites.TYPE_TASK) &&
                              !hasCompletionDate
                          ? Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: ShowUp(
                                    child: InkWell(
                                      child: Text(
                                        "Click to add Est. Complete Date",
                                        style: textTheme.caption.copyWith(
                                          fontSize: 13,
                                          color: Colors.red,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          hasCompletionDate = true;
                                        });
                                      },
                                    ),
                                    delay: 1000,
                                  ),
                                ),
                                widget.id.isEmpty ||
                                        isEdit &&
                                            (widget.type ==
                                                Activites.TYPE_TASK) &&
                                            !hasCompletionDate &&
                                            !hasCompletionDate
                                    ? Container(
                                        height: 1,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        color: Colors.red,
                                        margin: EdgeInsets.only(
                                            left: 0,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.0,
                                            top: 2,
                                            bottom: 0),
                                      )
                                    : Container(),
                              ],
                            )
                          : hasCompletionDate
                              ? GestureDetector(
                                  child: AbsorbPointer(
                                    child: TextField(
                                      enabled: widget.id.isEmpty || isEdit,
                                      controller: _completionDateController,
                                      decoration: InputDecoration(
                                        labelText: "Completion Date",
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              202, 208, 215, 1.0),
                                        ),
                                        errorText: _errorCompletionDate,
                                        border: widget.id.isEmpty || isEdit
                                            ? null
                                            : InputBorder.none,
                                      ),
                                      style: textTheme.subhead.copyWith(
                                        color: qDarkmodeEnable
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (widget.id.isEmpty || isEdit) {
                                      final DateTime picked =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        initialDate: DateTime.now(),
                                        lastDate: DateTime(2022),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          completionDate = picked;
                                          _completionDateController.text =
                                              "${formatDate(picked, [
                                            mm,
                                            '-',
                                            dd,
                                            '-',
                                            yy
                                          ])}";
                                        });
                                      }
                                    }
                                  },
                                )
                              : Container(),
                      // (widget.type == Activites.TYPE_BAND_TASK)
                      //     ? Text("Select Bands")
                      //     : Container(),
                      // Padding(
                      //   padding: EdgeInsets.all(3),
                      // ),
                      // (widget.id.isEmpty || isEdit) &&
                      //         (widget.type == Activites.TYPE_BAND_TASK)
                      //     ? Wrap(
                      //         children: items,
                      //       )
                      //     : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      selectedBand != null && selectedBand.bandmates.length > 0
                          ? Text("Select Band Members")
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      selectedBand != null
                          ? selectedBand.bandmates.length > 0
                              ? Wrap(
                                  children: items2,
                                )
                              : Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text("No Band Member"),
                                )
                          : Container(),
                      (widget.id.isEmpty || isEdit || widget.isParent) &&
                              (widget.type == Activites.TYPE_BAND_TASK)
                          ? Text(
                              "Task Notes",
                              textAlign: TextAlign.center,
                              style: textTheme.title,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
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
                                        Color.fromRGBO(40, 35, 188, 1.0),
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
                                              style: textTheme.caption.copyWith(
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
                                            style: textTheme.caption
                                                .copyWith(color: Colors.white),
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
                                if ((widget.type ==
                                        Activites.TYPE_PRACTICE_SCHEDULE) ||
                                    (widget.type ==
                                        Activites.TYPE_PERFORMANCE_SCHEDULE)) {
                                  if (_startTimeController.text.isEmpty) {
                                    showMessage(
                                        "Please select at least start time");
                                  } else if (endTime.hourOfPeriod <
                                      startTime.hourOfPeriod) {
                                    showMessage(
                                        "End Time must be later than Start Time");
                                  }
                                }
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
                                  }
                                  /* else if (widget.type ==
                                          Activites.TYPE_BAND_TASK &&
                                      selectedBandMember == null) {
                                    showMessage("Please select a band member");
                                  } */
                                  else {
                                    DateTime dateTime, dateTime2;
                                    if (widget.type ==
                                            Activites.TYPE_PRACTICE_SCHEDULE ||
                                        widget.type ==
                                            Activites
                                                .TYPE_PERFORMANCE_SCHEDULE ||
                                        widget.type ==
                                            Activites.TYPE_ACTIVITY) {
                                      dateTime = DateTime(
                                              startDate.year,
                                              startDate.month,
                                              startDate.day,
                                              startTime.hour,
                                              startTime.minute)
                                          .toUtc();
                                      dateTime2 = DateTime(
                                              endDate.year,
                                              endDate.month,
                                              endDate.day,
                                              endTime.hour,
                                              endTime.minute)
                                          .toUtc();
                                    }
                                    Activites activities = Activites(
                                        title: title,
                                        id: widget.id,
                                        bandId: widget.bandId,
                                        description: desc,
                                        startEventTime:
                                            _startEventTimeController.text,
                                        endEventTime:
                                            _endEventTimeController.text,
                                        bandTaskId: selectedBand?.id,
                                        bandTaskMemberId:
                                            selectedBandMember?.id,
                                        estCompleteDate: completionDate
                                            ?.toUtc()
                                            ?.millisecondsSinceEpoch,
                                        isRecurring: isRecurring,
                                        startDate: widget.type ==
                                                    Activites
                                                        .TYPE_PRACTICE_SCHEDULE ||
                                                widget.type ==
                                                    Activites
                                                        .TYPE_PERFORMANCE_SCHEDULE ||
                                                widget.type ==
                                                    Activites.TYPE_ACTIVITY
                                            ? dateTime?.toUtc()?.millisecondsSinceEpoch ??
                                                0
                                            : startDate
                                                .toUtc()
                                                .millisecondsSinceEpoch,
                                        endDate: widget.type ==
                                                    Activites.TYPE_PRACTICE_SCHEDULE ||
                                                widget.type == Activites.TYPE_PERFORMANCE_SCHEDULE ||
                                                widget.type == Activites.TYPE_ACTIVITY
                                            ? dateTime2?.toUtc()?.millisecondsSinceEpoch ?? 0
                                            : 0,
                                        location: loc,
                                        latitude: latitude,
                                        longitude: longitude,
                                        type: widget.type,
                                        parking: park,
                                        travelList: travelList,
                                        wardrobe: ward,
                                        other: other,
                                        startTime: _startTimeController.text.toLowerCase(),
                                        endTime: _endTimeController.text.toLowerCase());
                                    showLoading();
                                    presenter.addActivity(
                                        activities, widget.isParent);
                                  }
                                });
                              },
                              color: Color.fromRGBO(40, 35, 188, 1.0),
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
    Timer(new Duration(seconds: 2), () {
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
      if (activities.taskCompleteDate != null &&
          activities.taskCompleteDate != 0) {
        DateTime completionDate =
            DateTime.fromMillisecondsSinceEpoch(activities.taskCompleteDate);

        _taskCompletion.text =
            formatDate(completionDate, [D, ', ', mm, '-', dd, '-', yy]);
      }
      _startEventTimeController.text = activities.startEventTime;
      _endEventTimeController.text = activities.endEventTime;
      latitude = activities.latitude;
      longitude = activities.longitude;
      subActivities.clear();
      subActivities.addAll(activities.subActivities);
      _titleController.text = activities.title;
      _descController.text = activities.description;
      _taskController.text = activities.wardrobe;
      //_type = activities.action_type;
      startDate = DateTime.fromMillisecondsSinceEpoch(activities.startDate);
      _dateTxt = formatDate(startDate, [D, ', ', mm, '-', dd, '-', yy]);
      if (activities.estCompleteDate != null &&
          activities.estCompleteDate > 0) {
        _estDateTxt = formatDate(
            DateTime.fromMillisecondsSinceEpoch(activities.estCompleteDate),
            [D, ', ', mm, '-', dd, '-', yy]);
      }
      _dateController.text = formatDate(startDate, [mm, '-', dd, '-', yy]);
      _startTimeController.text = formatDate(startDate, [h, ':', nn, ' ', am]);
      selectedBandId = activities.bandTaskId;
      selectedBandMemberId = activities.bandTaskMemberId;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(activities.endDate ?? 0);
      _endDateController.text = formatDate(dateTime, [mm, '-', dd, '-', yy]);
      _dateEndTxt = formatDate(dateTime, [D, ', ', mm, '-', dd, '-', yy]);

      _endTimeController.text = formatDate(dateTime, [h, ':', nn, ' ', am]);

      _locController.text = activities.location;
      _parkingController.text = activities.parking;
      _otherController.text = activities.other;
      isRecurring = activities.isRecurring;
      //      _timeController.text = "at ${formatDate(dateT
      //      ime, [hh, ':', nn, am])}";
      members.clear();
      if (widget.id.isEmpty && widget.type == Activites.TYPE_BAND_TASK) {
        presenter.getUserBands();
      }
      travelList = activities.travelList;
      userId = activities.userId;
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
    if (widget.id.isEmpty && widget.type == Activites.TYPE_BAND_TASK) {
      selectedBandId = widget.bandId;
      presenter.getUserBands();
      presenter.getBandDetails(widget.bandId);
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
              child: new Text(
                "Yes",
                style: TextStyle(
                    color: qDarkmodeEnable ? Colors.white : Colors.black),
              ),
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  Navigator.of(context).pop();
                  presenter.activityDelete(widget.id);
                }
              },
            ),
            new FlatButton(
              child: new Text("No"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(40, 35, 188, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showDialogConfirm() {
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
            "Information!",
            textAlign: TextAlign.center,
          ),
          content: Text("In development..."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text(
                "Okay",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(22, 102, 237, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void getUserBands(List<Band> bands) {
    setState(() {
      this.bands.clear();
      this.bands.addAll(bands);
      if (selectedBandId != null) {
        for (Band b in bands) {
          if (b.id == selectedBandId) {
            selectedBand = b;
            break;
          }
        }
      }
      if (selectedBand != null && selectedBandMemberId != null) {
        for (BandMember bm in selectedBand.bandmates.values) {
          if (bm.id == selectedBandMemberId) {
            selectedBandMember = bm;
            break;
          }
        }
      }
    });
  }

  @override
  void getBandDetails(Band res) {
    setState(() {
      selectedBand = res;
    });
  }

  @override
  void onDelete() {
    Navigator.of(context).pop();
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

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyBPyhyGOHdrur7NmsyLStjhpitr_6IknCc",
            )));
    // Handle the result in your way
    latitude = result.latLng.latitude;
    longitude = result.latLng.longitude;
    _locController.text = (result.name + ',' + result.formattedAddress);
    print(result);
  }
}
