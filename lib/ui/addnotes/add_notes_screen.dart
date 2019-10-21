import 'dart:core' as prefix0;
import 'dart:core';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/ui/addnotes/add_notes_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:gigtrack/utils/showup.dart';

class AddNotesScreen extends BaseScreen {
  final String id;
  final bool isParent;
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  AddNotesScreen(
    AppListener appListener, {
    this.id,
    this.isParent = false,
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "");

  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}

class _AddNotesScreenState
    extends BaseScreenState<AddNotesScreen, AddNotesPresenter>
    implements AddNoteContract {
  final _descController = TextEditingController(),
      _noteController = TextEditingController(),
      _startDateController = TextEditingController(),
      _startTimeController = TextEditingController(),
      _endDateController = TextEditingController(),
      _createdDateController = TextEditingController(),
      _endTimeController = TextEditingController();

  String _descError,
      _startDateError,
      _endDateError,
      _startTimeError,
      _endTimeError,
      _noteError;

  int _type = 0;

  DateTime selectedStartDate, selectedEndDate = DateTime.now();
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
    getDetails();
  }

  bool isEdit = false;
  bool isDateVisible = false;
  bool isshowTitle = false;

  @override
  AppBar get appBar => AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (isEdit) {
              final check = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Your changes will not save.Are you sure?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  );
                },
              );
              if (check) {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        backgroundColor: Color.fromRGBO(22, 102, 237, 1.0),
        actions: <Widget>[
          widget.id.isEmpty || widget.isParent
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                      isshowTitle = true;
                    });
                  },
                ),
          widget.id.isEmpty || widget.isParent
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
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
            color: Color.fromRGBO(22, 102, 237, 1.0),
            height: height / 2.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.id.isEmpty ? "Add Note" : widget.isParent ? "Note is about" : "Note"}",
                style: textTheme.display2
                    .copyWith(color: Colors.white, fontSize: 30),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      Padding(
                        padding: widget.id.isEmpty || isEdit
                            ? EdgeInsets.all(5)
                            : EdgeInsets.all(0),
                      ),
                      //                      widget.id.isNotEmpty||isEdit
                      //                          ? Text(
                      //                       !isshowTitle?"Note is about":"",
                      //                        textAlign: TextAlign.left,
                      //                        style: TextStyle(
                      //                          fontSize: 17,
                      //                          fontWeight:  FontWeight.bold
                      //                        ),
                      //                      )
                      //                          : Container(),
                      Padding(
                        padding: widget.id.isEmpty || isEdit
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                errorText: _noteError,
                                labelText: widget.id.isEmpty || isEdit
                                    ? "Note is about"
                                    : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                border: widget.id.isEmpty ||
                                        isEdit ||
                                        widget.isParent
                                    ? null
                                    : InputBorder.none,
                              ),
                              controller: _noteController,
                            )
                          : Text(
                              _noteController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                      Padding(
                        padding: widget.id.isEmpty || isEdit || widget.isParent
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(5),
                      ),
                      //                      widget.id.isNotEmpty||isEdit
                      //                          ? Text(
                      //                        !isshowTitle?"Note Description":"",
                      //                        textAlign: TextAlign.left,
                      //                        style: TextStyle(
                      //                            fontSize: 18,
                      //                            fontWeight:  FontWeight.bold
                      //                        ),
                      //                      )
                      //                          : Container(),
                      Padding(
                        padding: widget.id.isEmpty || isEdit || widget.isParent
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? TextField(
                              enabled: widget.id.isEmpty ||
                                  isEdit ||
                                  widget.isParent,
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty ||
                                        isEdit ||
                                        widget.isParent
                                    ? "Add Note"
                                    : "",
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                    fontSize: 18),
                                border: widget.id.isEmpty ||
                                        isEdit ||
                                        widget.isParent
                                    ? null
                                    : InputBorder.none,
                              ),
                              controller: _descController,
                            )
                          : Text(
                              _descController.text,
                              style: TextStyle(fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? ShowUp(
                              child: !isDateVisible
                                  ? new GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isDateVisible = true;
                                        });
                                      },
                                      child: Text(
                                        "Click here to remind me",
                                        style: textTheme.display1.copyWith(
                                            color: widget
                                                .appListener.primaryColorDark,
                                            fontSize: 14),
                                      ),
                                    )
                                  : Container(),
                              delay: 1000,
                            )
                          : Container(),

                      Padding(
                        padding: widget.id.isEmpty || isEdit || widget.isParent
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(10),
                      ),
                      isDateVisible
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    child: AbsorbPointer(
                                      child: widget.id.isEmpty || isEdit
                                          ? TextField(
                                              enabled: widget.id.isEmpty,
                                              decoration: InputDecoration(
                                                labelText:
                                                    widget.id.isEmpty || isEdit
                                                        ? "Enter Reminder Date"
                                                        : "",
                                                labelStyle: TextStyle(
                                                    color: Color.fromRGBO(
                                                        202, 208, 215, 1.0),
                                                    fontSize: 18),
                                                border:
                                                    widget.id.isEmpty || isEdit
                                                        ? null
                                                        : InputBorder.none,
                                              ),
                                              controller: _startDateController,
                                            )
                                          : Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                      ),
                                                      Expanded(
                                                        flex: 5,
                                                        child: Text(
                                                          "Note Date",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: textTheme
                                                              .subtitle
                                                              .copyWith(
                                                                  //fontWeight: FontWeight.w600,
                                                                  ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          " - ",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          _createdDateController
                                                              .text,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        flex: 5,
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(1),
                                                  ),
                                                  _startDateController
                                                          .text.isNotEmpty
                                                      ? Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                            ),
                                                            Expanded(
                                                              flex: 5,
                                                              child: Text(
                                                                "Reminder Date",
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: textTheme
                                                                    .subtitle
                                                                    .copyWith(
                                                                        //fontWeight: FontWeight.w600,
                                                                        ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                " - ",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                _startDateController
                                                                    .text,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              flex: 5,
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                    ),
                                    onTap: () {
                                      if (widget.id.isEmpty || isEdit)
                                        _selectDate(context, true);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                ),
                              ],
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.all(10),
                            ),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : ShowUp(
                              child: new GestureDetector(
                                onTap: () async {
                                  await widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDNOTE.toString() +
                                          "/${widget.id}/true/${widget.bandId}////");
                                  getDetails();
                                },
                                child: Text(
                                  "Click here to add notes",
                                  textAlign: TextAlign.center,
                                  style: textTheme.display1.copyWith(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                              delay: 1000,
                            ),
//                      widget.id.isEmpty || isEdit || widget.isParent
//                          ? Container()
//                          : Padding(
//                              padding: EdgeInsets.only(top: 10, left: 10),
//                              child: Text(
//                                "Additionally Notes",
//                                style: textTheme.subtitle
//                                    .copyWith(fontWeight: FontWeight.bold),
//                              ),
//                            ),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? Container()
                          : ListView.builder(
                              itemCount: subNotes.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                NotesTodo notesTodo = subNotes[index];
                                DateTime dateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        notesTodo.createdDate);
                                return ListTile(
                                  title: Text(notesTodo.note),
                                  subtitle: Text(notesTodo.description),
                                  leading: CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(22, 102, 237, 1.0),
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
                                                style:
                                                    textTheme.caption.copyWith(
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
                                              style: textTheme.caption.copyWith(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            ),
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      widget.id.isEmpty || isEdit || widget.isParent
                          ? RaisedButton(
                              onPressed: () {
                                String desc = _descController.text;
                                String endDate = _endDateController.text;
                                String note = _noteController.text;

                                setState(() {
                                  _descError = null;
                                  _startDateError = null;
                                  _endDateError = null;
                                  _startTimeError = null;
                                  _endTimeError = null;
                                  if (desc.isEmpty) {
                                    _descError = "Cannot be Empty";
                                  } else {
                                    DateTime end;
                                    if (endDate != null) {
                                      end = DateTime(
                                          selectedEndDate.year,
                                          selectedEndDate.month,
                                          selectedEndDate.day,
                                          selectedEndTime.hour,
                                          selectedEndTime.minute);
                                    }
                                    NotesTodo notesTodo = NotesTodo(
                                      description: desc,
                                      bandId: widget.bandId,
                                      end_date:
                                          end?.millisecondsSinceEpoch ?? 0,
                                      start_date: selectedStartDate != null
                                          ? selectedStartDate
                                              .millisecondsSinceEpoch
                                          : 0,
                                      type: _type,
                                      id: widget.id,
                                      note: note,
                                      createdDate:
                                          DateTime.now().millisecondsSinceEpoch,
                                    );
                                    showLoading();
                                    presenter.addNotes(
                                        notesTodo, widget.isParent);
                                  }
                                });
                              },
                              color: Color.fromRGBO(22, 102, 237, 1.0),
                              child: Text(
                                "Submit",
                                style: textTheme.headline.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textColor: Colors.white,
                            )
                          : Container()
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
  void onSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created Successfully");
    Navigator.of(context).pop();
  }

  List<NotesTodo> subNotes = [];

  @override
  void getNoteDetails(NotesTodo note) {
    hideLoading();
    setState(() {
      subNotes.clear();
      subNotes.addAll(note.subNotes);
      _descController.text = note.description;
      _noteController.text = note.note;
      DateTime createdDate =
          DateTime.fromMillisecondsSinceEpoch((note.createdDate));
      DateTime stDate = DateTime.fromMillisecondsSinceEpoch((note.start_date));
      DateTime endDate = DateTime.fromMillisecondsSinceEpoch((note.end_date));
      _createdDateController.text =
          "${formatDate(stDate, [mm, '/', dd, '/', yy])}";
      if (note.start_date == 0) {
        _startDateController.text = null;
        isDateVisible = false;
      } else {
        isDateVisible = true;
        selectedStartDate =
            DateTime.fromMillisecondsSinceEpoch((note.start_date));
        _startDateController.text =
            "${formatDate(stDate, [mm, '/', dd, '/', yy])}";
      }
      _endDateController.text =
          "${formatDate(endDate, [yyyy, '-', mm, '-', dd])}";
      _startTimeController.text =
          "${formatDate(stDate, [HH, ':', nn, ':', ss])}";
      _endTimeController.text =
          "${formatDate(endDate, [HH, ':', nn, ':', ss])}";
    });
  }

  @override
  void onUpdate() {
    showMessage("Updated Successfully");
  }

  @override
  void onSubSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created SubNote Successfully");
    Navigator.of(context).pop();
  }

  void getDetails() {
    if (widget.id.isNotEmpty && !widget.isParent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getNotesDetails(widget.id);
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
              color: Color.fromRGBO(239, 181, 77, 1.0),
              onPressed: () async {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  presenter.notesDelete(widget.id);
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).popUntil(ModalRoute.withName(
                        Screens.NOTETODOLIST.toString() + "/////"));
                  });
//                SchedulerBinding.instance.addPostFrameCallback((_) {
//                  Navigator.of(context).popUntil(ModalRoute.withName(Screens.NOTETODOLIST.toString()));
//                });

                }
              },
            ),
          ],
        );
      },
    );
  }
}
