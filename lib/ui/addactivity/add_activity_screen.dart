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
      _timeController = TextEditingController(),
      _descController = TextEditingController(),
      _locController = TextEditingController();
  final List<Band> bands = [];
  final List<User> members = [];

  String _titleError, _dateError, _timeError, _descError, _locError;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  int _userType = 0, _type = 0;

  Band selectedBand;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = formatDate(selectedDate, [mm, '-', dd, '-', yy]);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        _timeController.text = (selectedTime.format(context));
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
    presenter.getBands();
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
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              Text(
                "${widget.id.isEmpty ? "Add" : ""} Activities/Schedule",
                style: textTheme.display2.copyWith(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(
                child: Card(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      widget.id.isEmpty
                          ? Text(
                              "Select One from each row:",
                              style: textTheme.headline.copyWith(
                                  color: widget.appListener.primaryColorDark),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(6),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: widget.id.isEmpty
                                ? () {
                                    _handleUserTypeValueChange(0);
                                  }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                  color: _userType == 0
                                      ? Color.fromRGBO(209, 244, 236, 1.0)
                                      : Color.fromRGBO(244, 246, 248, 1.0),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: _userType == 0
                                          ? Color.fromRGBO(70, 206, 172, 1.0)
                                          : Color.fromRGBO(
                                              244, 246, 248, 1.0))),
                              child: Text(
                                'User',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: _userType == 0
                                      ? Color.fromRGBO(70, 206, 172, 1.0)
                                      : Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                          ),
                          InkWell(
                            onTap: widget.id.isEmpty
                                ? () {
                                    _handleUserTypeValueChange(1);
                                  }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                  color: _userType == 1
                                      ? Color.fromRGBO(209, 244, 236, 1.0)
                                      : Color.fromRGBO(244, 246, 248, 1.0),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: _userType == 1
                                          ? Color.fromRGBO(70, 206, 172, 1.0)
                                          : Color.fromRGBO(
                                              244, 246, 248, 1.0))),
                              child: Text(
                                'Band',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: _userType == 1
                                      ? Color.fromRGBO(70, 206, 172, 1.0)
                                      : Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      (_userType == 1 && widget.id.isEmpty)
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
                        padding: EdgeInsets.all(8),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: widget.id.isEmpty
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
                                      : Color.fromRGBO(244, 246, 248, 1.0),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: _type == 0
                                          ? Color.fromRGBO(70, 206, 172, 1.0)
                                          : Color.fromRGBO(
                                              244, 246, 248, 1.0))),
                              child: Text(
                                'Schedule',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: _type == 0
                                      ? Color.fromRGBO(70, 206, 172, 1.0)
                                      : Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                          ),
                          InkWell(
                            onTap: widget.id.isEmpty
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
                                      : Color.fromRGBO(244, 246, 248, 1.0),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: _type == 1
                                          ? Color.fromRGBO(70, 206, 172, 1.0)
                                          : Color.fromRGBO(
                                              244, 246, 248, 1.0))),
                              child: Text(
                                'Activity',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: _type == 1
                                      ? Color.fromRGBO(70, 206, 172, 1.0)
                                      : Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        enabled: widget.id.isEmpty,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: widget.id.isEmpty ? "Title" : "",
                          labelStyle: textTheme.headline.copyWith(
                            color: Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          errorText: _titleError,
                          border: widget.id.isEmpty ? null : InputBorder.none,
                        ),
                        style: widget.id.isEmpty
                            ? textTheme.subhead.copyWith(
                                color: Colors.black,
                              )
                            : textTheme.display1.copyWith(
                                color: Colors.black,
                              ),
                        controller: _titleController,
                      ),
                      Row(
                        children: <Widget>[
                          widget.id.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ),
                          Expanded(
                            child: widget.id.isEmpty
                                ? InkWell(
                                    child: AbsorbPointer(
                                      child: TextField(
                                        enabled: widget.id.isEmpty,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          labelText:
                                              widget.id.isEmpty ? "Date" : "",
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                          ),
                                          errorText: _dateError,
                                          border: widget.id.isEmpty
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
                                      if (widget.id.isEmpty)
                                        _selectDate(context);
                                    },
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      _dateController.text,
                                      style: textTheme.subhead.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          widget.id.isEmpty
                              ? Expanded(
                                  child: InkWell(
                                    child: AbsorbPointer(
                                      child: TextField(
                                        enabled: widget.id.isEmpty,
                                        decoration: InputDecoration(
                                          labelText:
                                              widget.id.isEmpty ? "Time" : "",
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                202, 208, 215, 1.0),
                                          ),
                                          errorText: _timeError,
                                          border: widget.id.isEmpty
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
                                      if (widget.id.isEmpty)
                                        _selectTime(context);
                                    },
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      widget.id.isEmpty
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
                                    labelText:
                                        widget.id.isEmpty ? "Location" : "",
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(202, 208, 215, 1.0),
                                    ),
                                    errorText: _locError,
                                    border: widget.id.isEmpty
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  enabled: widget.id.isEmpty,
                                  controller: _locController,
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                top: 15,
                              ),
                              child: Row(
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
                                        style: textTheme.subhead.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: widget.id.isEmpty ? "Description" : "",
                          labelStyle: TextStyle(
                            color: Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          errorText: _descError,
                          border: widget.id.isEmpty ? null : InputBorder.none,
                        ),
                        enabled: widget.id.isEmpty,
                        minLines: 5,
                        maxLines: 10,
                        style: textTheme.subhead.copyWith(
                          color: Colors.black,
                        ),
                        controller: _descController,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      widget.id.isEmpty
                          ? RaisedButton(
                              onPressed: () {
                                String title = _titleController.text;
                                String desc = _descController.text;
                                String loc = _locController.text;
                                String time = _timeController.text;
                                String date = _dateController.text;
                                setState(() {
                                  _titleError = null;
                                  _descError = null;
                                  _locError = null;
                                  _timeError = null;
                                  _dateError = null;
                                  if (title.isEmpty) {
                                    _titleError = "Cannot be Empty";
                                  } else if (desc.isEmpty) {
                                    _descError = "Cannot be Empty";
                                  } else if (loc.isEmpty) {
                                    _locError = "Cannot be Empty";
                                  } else if (time.isEmpty) {
                                    _timeError = "Cannot be Empty";
                                  } else if (date.isEmpty) {
                                    _dateError = "Cannot be Empty";
                                  } else {
                                    Activites activities = Activites(
                                      title: title,
                                      description: desc,
                                      date: "$date $time",
                                      location: loc,
                                      band_id: selectedBand?.id ?? "",
                                      type: _userType.toString(),
                                      action_type: _type.toString(),
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
                      widget.id.isEmpty
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
                      widget.id.isEmpty
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
    Navigator.pop(context);
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
    });
  }

  @override
  void getActivityDetails(Activites activities) {
    hideLoading();
    setState(() {
      _titleController.text = activities.title;
      _descController.text = activities.description;
      _userType = int.tryParse(activities.type);
      _type = int.tryParse(activities.action_type);
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(activities.date));
      _dateController.text =
          formatDate(dateTime, [DD, ', ', mm, '-', dd, '-', yy]) +
              " at ${formatDate(dateTime, [hh, ':', nn, am])}";
      _locController.text = activities.location;
//      _timeController.text = "at ${formatDate(dateTime, [hh, ':', nn, am])}";
      members.clear();
      members.addAll(activities.bandmates);
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
}
