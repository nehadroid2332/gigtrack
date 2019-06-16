import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addnotes/add_notes_presenter.dart';

class AddNotesScreen extends BaseScreen {
  AddNotesScreen(AppListener appListener)
      : super(appListener, title: "Add Notes/Todo");

  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}

class _AddNotesScreenState
    extends BaseScreenState<AddNotesScreen, AddNotesPresenter> {
  final _descController = TextEditingController(),
      _startDateController = TextEditingController(),
      _startTimeController = TextEditingController(),
      _endDateController = TextEditingController(),
      _endTimeController = TextEditingController();

  String _descError,
      _startDateError,
      _endDateError,
      _startTimeError,
      _endTimeError;

  int _type = 0;

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
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Text("Type"),
        Row(
          children: <Widget>[
            new Radio(
              value: 0,
              groupValue: _type,
              onChanged: _handleTypeValueChange,
            ),
            new Text(
              'Note',
              style: new TextStyle(fontSize: 16.0),
            ),
            new Radio(
              value: 1,
              groupValue: _type,
              onChanged: _handleTypeValueChange,
            ),
            new Text(
              'ToDO',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        TextField(
          decoration: InputDecoration(hintText: "Desc"),
          controller: _descController,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Start Date"),
                    controller: _startDateController,
                  ),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Start Time"),
                    controller: _startTimeController,
                  ),
                ),
                onTap: () {},
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(labelText: "End Date"),
                    controller: _endDateController,
                  ),
                ),
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(labelText: "End Time"),
                    controller: _endTimeController,
                  ),
                ),
                onTap: () {},
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(20),
        ),
        RaisedButton(
          onPressed: () {
            String desc = _descController.text;
            String stDate = _startDateController.text;
            String stTime = _startTimeController.text;
            String endDate = _endDateController.text;
            String endTime = _endTimeController.text;

            setState(() {
              _descError = null;
              _startDateError = null;
              _endDateError = null;
              _startTimeError = null;
              _endTimeError = null;
              if (desc.isEmpty) {
                _descError = "Cannot be Empty";
              } else if (stDate.isEmpty) {
                _startDateError = "Cannot be Empty";
              } else if (stTime.isEmpty) {
                _startTimeError = "Cannot be Empty";
              } else if (endDate.isEmpty) {
                _endDateError = "Cannot be Empty";
              } else if (endTime.isEmpty) {
                _endTimeError = "Cannot be Empty";
              } else {}
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
  AddNotesPresenter get presenter => AddNotesPresenter(this);
}
