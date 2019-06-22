import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/ui/addactivity/add_activity_presenter.dart';

class AddActivityScreen extends BaseScreen {
  AddActivityScreen(AppListener appListener)
      : super(appListener, title: "Add Activity/Schedule");

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

  String _titleError, _dateError, _timeError, _descError, _locError;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  int _userType = 0, _type = 0;

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
            formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
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
  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Text("Type"),
        Row(
          children: <Widget>[
            new Radio(
              value: 0,
              groupValue: _userType,
              onChanged: _handleUserTypeValueChange,
            ),
            new Text(
              'User',
              style: new TextStyle(fontSize: 16.0),
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
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8),
        ),
        Row(
          children: <Widget>[
            new Radio(
              value: 0,
              groupValue: _type,
              onChanged: _handleTypeValueChange,
            ),
            new Text(
              'Schedule',
              style: new TextStyle(fontSize: 16.0),
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
              ),
            ),
          ],
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Enter Title",
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
                    decoration: InputDecoration(
                      labelText: "Date",
                      errorText: _dateError,
                    ),
                    controller: _dateController,
                  ),
                ),
                onTap: () {
                  _selectDate(context);
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
                    decoration: InputDecoration(
                      labelText: "Time",
                      errorText: _timeError,
                    ),
                    controller: _timeController,
                  ),
                ),
                onTap: () {
                  _selectTime(context);
                },
              ),
            )
          ],
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Location",
            errorText: _locError,
          ),
          controller: _locController,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Description",
            errorText: _descError,
          ),
          minLines: 5,
          maxLines: 10,
          controller: _descController,
        ),
        Padding(
          padding: EdgeInsets.all(20),
        ),
        RaisedButton(
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
                  date: date,
                  location: loc,
                  type: _userType,
                  action_type: _type,
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
      ],
    );
  }

  @override
  AddActivityPresenter get presenter => AddActivityPresenter(this);

  @override
  void onSuccess(ActivitiesResponse res) {
    hideLoading();
    showMessage(res.message);
    Navigator.pop(context);
  }
}
