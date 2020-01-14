import 'dart:core' as prefix0;
import 'dart:core';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/ui/addbulletinboard/addbulletinboard_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class AddBulletInBoardScreen extends BaseScreen {
  final String id;

  AddBulletInBoardScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _AddBulletInBoardScreenState createState() => _AddBulletInBoardScreenState();
}

class _AddBulletInBoardScreenState
    extends BaseScreenState<AddBulletInBoardScreen, AddBuiltInBoardPresenter>
    implements AddBulletInBoardContract {
  final _descController = TextEditingController(),
      _noteController = TextEditingController(),
      _startDateController = TextEditingController();

  String _descError, _startDateError, _noteError;

  DateTime selectedStartDate;

  String bulletInUserId;
  var visibleDays = 1;

  int status = BulletInBoard.STATUS_PENDING;

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
                    title: Text("Do you want to save changes?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          _submitBulletin();
                          Navigator.of(context).pop(true);
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
        backgroundColor: Color.fromRGBO(214, 22, 35, 1.0),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: widget.id.isEmpty
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2,
            child: Text(
              "${widget.id.isEmpty ? "Add" : ""} Bulletin Board",
              textAlign: TextAlign.center,
              style: textTheme.headline.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          widget.id.isEmpty
              ? Container()
              : (bulletInUserId != null) &&
                      ((bulletInUserId == presenter.serverAPI.currentUserId) ||
                          (presenter.serverAPI.currentUserId ==
                              presenter.serverAPI.adminEmail))
                  ? IconButton(
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
                    )
                  : Container(),
          widget.id.isEmpty
              ? Container()
              : bulletInUserId != null &&
                      ((bulletInUserId == presenter.serverAPI.currentUserId) ||
                          (presenter.serverAPI.currentUserId ==
                              presenter.serverAPI.adminEmail))
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showDialogConfirm();
                      },
                    )
                  : Container()
        ],
      );

  final types = <String>[
    "Audition",
    "Fill-in Needed",
    "Attend",
    "Notice",
    "FYI",
    "Method",
    "Available",
    "Advertise",
    "Used Equipment"
  ];
  String type = "";

  @override
  Widget buildBody() {
    List<Widget> items = [];
    for (String s in types) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: type == s
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: type == s
                ? Color.fromRGBO(214, 22, 35, 1.0)
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
                  type = s;
                });
              }
            : null,
      ));
    }
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 4.5),
          child: Container(
            color: Color.fromRGBO(214, 22, 35, 1.0),
            height: height / 4.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
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
                      Padding(
                        padding: widget.id.isEmpty || isEdit
                            ? EdgeInsets.all(0)
                            : EdgeInsets.all(5),
                      ),
                      !(widget.id.isEmpty || isEdit)
                          ? Container(
                              margin: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          "Post Date",
                                          textAlign: TextAlign.right,
                                          style: textTheme.title.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600
                                              //fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          " - ",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _startDateController.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        flex: 5,
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(1),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                errorText: _noteError,
                                labelText: widget.id.isEmpty || isEdit
                                    ? "Enter Item"
                                    : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              controller: _noteController,
                            )
                          : Text(
                              _noteController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        "Type",
                        textAlign: widget.id.isEmpty || isEdit
                            ? TextAlign.left
                            : TextAlign.center,
                        style: textTheme.title
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      widget.id.isEmpty || isEdit
                          ? Wrap(
                              children: items,
                            )
                          : type.isNotEmpty
                              ? Text(
                                  type,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isNotEmpty
                          ? Text(
                              isEdit ? "" : "Description",
                              textAlign: widget.id.isEmpty || isEdit
                                  ? TextAlign.left
                                  : TextAlign.center,
                              style: textTheme.title
                                  .copyWith(fontWeight: FontWeight.w600),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(3),
                      ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty || isEdit
                                    ? "Add message"
                                    : "",
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                    fontSize: 18),
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              controller: _descController,
                            )
                          : Text(
                              _descController.text,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
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
                                                    ? "Date"
                                                    : "",
                                            labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    202, 208, 215, 1.0),
                                                fontSize: 18),
                                            border: widget.id.isEmpty || isEdit
                                                ? null
                                                : InputBorder.none,
                                          ),
                                          controller: _startDateController,
                                        )
                                      : Container()),
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
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                      ),
                      widget.id.isEmpty || isEdit
                          ? RaisedButton(
                              onPressed: () {
                                _submitBulletin();
                              },
                              color: Color.fromRGBO(214, 22, 35, 1.0),
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
                          : Container(),
                      widget.id.isEmpty
                          ? Container()
                          : presenter.serverAPI.currentUserId ==
                                      presenter.serverAPI.adminEmail &&
                                  (status == null ||
                                      status == BulletInBoard.STATUS_PENDING)
                              ? Text("Select number of days to visible")
                              : Container(),
                      widget.id.isEmpty
                          ? Container()
                          : presenter.serverAPI.currentUserId ==
                                      presenter.serverAPI.adminEmail &&
                                  (status == null ||
                                      status == BulletInBoard.STATUS_PENDING)
                              ? new DropdownButton<int>(
                                  items: <int>[1, 2, 3, 4, 5, 6, 7]
                                      .map((int value) {
                                    return new DropdownMenuItem<int>(
                                      value: value,
                                      child: new Text("$value"),
                                    );
                                  }).toList(),
                                  onChanged: (a) {
                                    setState(() {
                                      visibleDays = a;
                                    });
                                  },
                                  value: visibleDays,
                                )
                              : Container(),
                      widget.id.isEmpty || isEdit
                          ? Container()
                          : presenter.serverAPI.currentUserId ==
                                      presenter.serverAPI.adminEmail &&
                                  (status == null ||
                                      status == BulletInBoard.STATUS_PENDING)
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: RaisedButton(
                                        color: Color.fromRGBO(214, 22, 35, 1.0),
                                        onPressed: () {
                                          presenter.updateStatus(
                                              widget.id,
                                              BulletInBoard.STATUS_APPROVED,
                                              visibleDays);
                                        },
                                        child: Text(
                                          "Approve",
                                          style: textTheme.button.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Expanded(
                                      child: RaisedButton(
                                        onPressed: () {
                                          presenter.updateStatus(
                                              widget.id,
                                              BulletInBoard.STATUS_DECLINED,
                                              visibleDays);
                                        },
                                        color: Colors.white,
                                        child: Text(
                                          "Declined",
                                          style: textTheme.button.copyWith(
                                            color: Color.fromRGBO(
                                                214, 22, 35, 1.0),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
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
        } else {}
      });
  }

  Future<Null> _selectTime(BuildContext context, bool isStart) async {
    // final TimeOfDay picked = await showTimePicker(
    //   context: context,
    //   initialTime: selectedStartTime,
    // );
    // if (picked != null && picked != selectedStartTime)
    //   setState(() {
    //     if (isStart) {
    //       selectedStartTime = picked;
    //       _startTimeController.text = selectedStartTime.format(context);
    //     } else {
    //       selectedEndTime = picked;
    //       _endTimeController.text = selectedEndTime.format(context);
    //     }
    //   });
  }

  @override
  AddBuiltInBoardPresenter get presenter => AddBuiltInBoardPresenter(this);

  @override
  void onSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created Successfully");
    Navigator.of(context).pop();
  }

  @override
  void getBulletInBoardDetails(BulletInBoard note) {
    hideLoading();
    setState(() {
      bulletInUserId = note.user_id;
      type = note.type;
      status = note.status;
      _descController.text = note.description;
      _noteController.text = note.item;
      DateTime stDate = DateTime.fromMillisecondsSinceEpoch((note.date));
      _startDateController.text =
          "${formatDate(stDate, [mm, '/', dd, '/', yy])}";
    });
  }

  @override
  void onUpdate() {
    showMessage("Updated Successfully");
    setState(() {
      isEdit = !isEdit;
    });
    presenter.getBulletInBoardDetails(widget.id);
  }

  @override
  void onSubSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created SubNote Successfully");
    Navigator.of(context).pop();
  }

  void getDetails() {
    if (widget.id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showLoading();
        presenter.getBulletInBoardDetails(widget.id);
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
              child: new Text("Yes"),
              textColor: Colors.black,
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  presenter.bulletinboardDelete(widget.id);
                  Navigator.of(context).popUntil(
                      ModalRoute.withName(Screens.BULLETINLISTLIST.toString()));
                }
              },
            ),
            new RaisedButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(214, 22, 35, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitBulletin() {
    String desc = _descController.text;
    String note = _noteController.text;

    setState(() {
      _descError = null;
      _startDateError = null;
      if (desc.isEmpty) {
        _descError = "Cannot be Empty";
      } else {
        BulletInBoard notesTodo = BulletInBoard(
          description: desc,
          date: selectedStartDate != null
              ? selectedStartDate.millisecondsSinceEpoch
              : 0,
          type: type,
          id: widget.id,
          item: note,
        );
        showLoading();
        presenter.addBulletIn(notesTodo);
      }
    });
  }
}
