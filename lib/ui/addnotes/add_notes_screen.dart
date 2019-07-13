import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/note_todo_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/addnotes/add_notes_presenter.dart';

class AddNotesScreen extends BaseScreen {
  final String id;

  AddNotesScreen(AppListener appListener, {this.id})
      : super(appListener, title: "Add Notes/Todo");

  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}

class _AddNotesScreenState
    extends BaseScreenState<AddNotesScreen, AddNotesPresenter>
    implements AddNoteContract {
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

  DateTime selectedStartDate = DateTime.now(), selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now(),
      selectedEndTime = TimeOfDay.now();

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
        presenter.getNotesDetails(widget.id);
      });
    }
  }

  @override
  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
        ),
        widget.id.isEmpty ? Text("Type") : Container(),
        widget.id.isEmpty
            ? Row(
                children: <Widget>[
                  new Radio(
                    value: 0,
                    groupValue: _type,
                    onChanged: _handleTypeValueChange,
                  ),
                  new Text(
                    'Note',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: _type,
                    onChanged: _handleTypeValueChange,
                  ),
                  new Text(
                    'ToDO',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              )
            : Container(),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        TextField(
          enabled: widget.id.isEmpty,
          decoration: InputDecoration(
            labelText: "Desc",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          controller: _descController,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: AbsorbPointer(
                  child: TextField(
                    enabled: widget.id.isEmpty,
                    decoration: InputDecoration(
                      labelText: "Start Date",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    controller: _startDateController,
                  ),
                ),
                onTap: () {
                  if (widget.id.isEmpty) _selectDate(context, true);
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
                    decoration: InputDecoration(
                      labelText: "Start Time",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    controller: _startTimeController,
                  ),
                ),
                onTap: () {
                  if (widget.id.isEmpty) _selectTime(context, true);
                },
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
                    enabled: widget.id.isEmpty,
                    decoration: InputDecoration(
                      labelText: "End Date",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    controller: _endDateController,
                  ),
                ),
                onTap: () {
                  if (widget.id.isEmpty) _selectDate(context, false);
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
                    decoration: InputDecoration(
                      labelText: "End Time",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    controller: _endTimeController,
                  ),
                ),
                onTap: () {
                  if (widget.id.isEmpty) _selectTime(context, false);
                },
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(20),
        ),
        widget.id.isEmpty
            ? RaisedButton(
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
                    } else {
                      NotesTodo notesTodo = NotesTodo(
                        description: desc,
                        end_date: endDate,
                        start_date: stDate,
                        type: _type.toString(),
                      );
                      showLoading();
                      presenter.addNotes(notesTodo);
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

  Future<Null> _selectDate(BuildContext context, bool isStart) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate)
      setState(() {
        if (isStart) {
          selectedStartDate = picked;
          _startDateController.text =
              formatDate(selectedStartDate, [mm, '-', dd, '-', yy]);
        } else {
          selectedEndDate = picked;
          _endDateController.text =
              formatDate(selectedEndDate, [mm, '-', dd, '-', yy]);
        }
      });
  }

  Future<Null> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime)
      setState(() {
        if (isStart) {
          selectedStartTime = picked;
          _startTimeController.text = selectedStartTime.format(context);
        } else {
          selectedEndTime = picked;
          _endTimeController.text = selectedEndTime.format(context);
        }
      });
  }

  @override
  AddNotesPresenter get presenter => AddNotesPresenter(this);

  @override
  void onSuccess(NoteTodoResponse res) {
    if (!mounted) return;
    hideLoading();
    showMessage(res.message);
    Navigator.of(context).pop();
  }

  @override
  void getNoteDetails(NotesTodo note) {
    hideLoading();
    setState(() {
      _descController.text = note.description;
      DateTime stDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(note.start_date));
      DateTime endDate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(note.end_date));
      _startDateController.text =
          "${formatDate(stDate, [yyyy, '-', mm, '-', dd])}";
      _endDateController.text =
          "${formatDate(endDate, [yyyy, '-', mm, '-', dd])}";
      _startTimeController.text =
          "${formatDate(stDate, [HH, ':', nn, ':', ss])}";
      _endTimeController.text =
          "${formatDate(endDate, [HH, ':', nn, ':', ss])}";
    });
  }
}
