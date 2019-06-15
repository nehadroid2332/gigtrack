import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addactivity/add_activity_presenter.dart';

class AddActivityScreen extends BaseScreen {
  AddActivityScreen(AppListener appListener)
      : super(appListener, title: "Add Activity/Schedule");

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState
    extends BaseScreenState<AddActivityScreen, AddActivityPresenter> {
  final _titleController = TextEditingController(),
      _dateController = TextEditingController(),
      _timeController = TextEditingController(),
      _descController = TextEditingController(),
      _locController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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

  @override
  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(labelText: "Enter Title"),
          controller: _titleController,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Date"),
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
                    decoration: InputDecoration(labelText: "Time"),
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
          decoration: InputDecoration(labelText: "Location"),
          controller: _locController,
        ),
        TextField(
          decoration: InputDecoration(labelText: "Description"),
          minLines: 5,
          maxLines: 10,
          controller: _descController,
        ),
        Padding(
          padding: EdgeInsets.all(20),
        ),
        RaisedButton(
          onPressed: () {},
          color: widget.appListener.primaryColor,
          child: Text("Submit"),
          textColor: Colors.white,
        )
      ],
    );
  }

  @override
  AddActivityPresenter get presenter => AddActivityPresenter(this);
}
