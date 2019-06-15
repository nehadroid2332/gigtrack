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

  @override
  Widget buildBody() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
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
          onPressed: () {},
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
