import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/ui/addactivity/add_activity_presenter.dart';

class AddActivityScreen extends BaseScreen {
  final String id;

  AddActivityScreen(AppListener appListener, {this.id})
      : super(appListener,
            title: "${id.isEmpty ? "Add " : ""}Activity/Schedule");

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
        _dateController.text =
            formatDate(selectedDate, [mm, '-', dd, '-', yy]);
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
  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        widget.id.isEmpty
            ? Text(
                "Select One from each row:",
                style: textTheme.subtitle.copyWith(color: Colors.white),
              )
            : Container(),
        widget.id.isEmpty
            ? Row(
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: _userType,
                    onChanged: _handleUserTypeValueChange,
                  ),
                  new Text(
                    'User',
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: _userType,
                    onChanged: _handleUserTypeValueChange,
                  ),
                  new Text(
                    'Band',
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Container(),
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
        widget.id.isEmpty
            ? Row(
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: _type,
                    onChanged: _handleTypeValueChange,
                  ),
                  new Text(
                    'Schedule',
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: _type,
                    onChanged: _handleTypeValueChange,
                  ),
                  new Text(
                    'Activity',
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Container(),
        TextField(
          enabled: widget.id.isEmpty,
          decoration: InputDecoration(
            labelText: "Enter Title",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            errorText: _titleError,
          ),
          controller: _titleController,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    enabled: widget.id.isEmpty,
                    decoration: InputDecoration(
                      labelText: "Date",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      errorText: _dateError,
                    ),
                    controller: _dateController,
                  ),
                ),
                onTap: () {
                  if (widget.id.isEmpty) _selectDate(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    enabled: widget.id.isEmpty,
                    style: textTheme.caption.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Time",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      errorText: _timeError,
                    ),
                    controller: _timeController,
                  ),
                ),
                onTap: () {
                  if (widget.id.isEmpty) _selectTime(context);
                },
              ),
            )
          ],
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Location",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            errorText: _locError,
          ),
          enabled: widget.id.isEmpty,
          controller: _locController,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Description",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            errorText: _descError,
          ),
          enabled: widget.id.isEmpty,
          minLines: 5,
          maxLines: 10,
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
                        band_id: selectedBand?.id,
                        type: _userType.toString(),
                        action_type: _type.toString(),
                      );
                      showLoading();
                      presenter.addActivity(activities);
                    }
                  });
                },
                color: widget.appListener.primaryColor,
                child: Text("Submit"),
                textColor: Colors.white,
              )
            : Container()
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
  void getActivtyDetails(Activites activities) {
    hideLoading();
    setState(() {
      _titleController.text = activities.title;
      _descController.text = activities.description;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(activities.date));
      _dateController.text = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
      _locController.text = activities.location;
      _timeController.text = "${formatDate(dateTime, [HH, ':', nn, ':', ss])}";
    });
  }
}
