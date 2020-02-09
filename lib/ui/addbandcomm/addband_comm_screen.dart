import 'dart:core' as prefix0;
import 'dart:core';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band_comm.dart';
import 'package:gigtrack/server/server_api.dart';
import 'package:gigtrack/ui/addbandcomm/addband_comm_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class AddBandCommScreen extends BaseScreen {
  final String id;
  final String bandId;
  final bool isParent;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;
  final int type;

  AddBandCommScreen(
    AppListener appListener, {
    this.id,
    this.bandId,
    this.isParent,
    this.isComm,
    this.isLeader,
    this.isSetUp,
    this.postEntries,
    this.type,
  }) : super(appListener, title: "");

  @override
  _AddBandCommScreenState createState() => _AddBandCommScreenState();
}

class _AddBandCommScreenState
    extends BaseScreenState<AddBandCommScreen, AddBandCommPresenter>
    implements AddBandCommContract {
  final _addCommController = TextEditingController(),
      _titleController = TextEditingController(),
      _responseDateController = TextEditingController();

  String _descError, _startDateError, _titleError;

  @override
  void initState() {
    super.initState();
    //serverAPI = ServerAPI();
    getDetails();
  }

  bool isEdit = false;

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
                  : (bandComm != null ? bandComm.userId : false) ==
                          presenter.serverAPI.currentUserId
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "${widget.id.isEmpty ? "Add" : ""} Band Communication",
                  textAlign: (bandComm != null ? bandComm.userId : false) ==
                          presenter.serverAPI.currentUserId
                      ? TextAlign.center
                      : TextAlign.left,
                  style: textTheme.headline.copyWith(
                    color: Colors.white,
                  ),
                ),
              )),
          widget.id.isEmpty
              ? Container()
              : ((bandComm != null ? bandComm.userId : false) ==
                      presenter.serverAPI.currentUserId&& widget.isLeader)
                  ? Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isEdit = !isEdit;
                          });
                        },
                      ),
                    )
                  : Container(
                      child: null,
                    ),
          widget.id.isEmpty
              ? Container()
              : ((bandComm != null ? bandComm.userId : false) ==
              presenter.serverAPI.currentUserId&& widget.isLeader)
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showDialogConfirm();
                      },
                    )
                  : Container(
                      child: null,
                    )
        ],
      );

  BandCommunication bandComm;

  List<String> priority = ["Low", "High"];

  @override
  Widget buildBody() {
    List<Widget> items = [];

    for (String s in priority) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: bandComm?.priority == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: bandComm?.priority == (s)
                ? Color.fromRGBO(250, 177, 49, 1.0)
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
                  bandComm.priority = s;
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
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                errorText: _titleError,
                                labelText:
                                    widget.id.isEmpty || isEdit ? "Title" : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              onChanged: (a) {
                                bandComm.title = a;
                              },
                              controller: _titleController,
                            )
                          : Text(
                              _titleController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? TextField(
                              enabled: widget.id.isEmpty || isEdit,
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: widget.id.isEmpty || isEdit
                                    ? "Add Communication"
                                    : "",
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                    fontSize: 18),
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              onChanged: (a) {
                                bandComm.addCommunication = a;
                              },
                              controller: _addCommController,
                            )
                          : Text(
                              _addCommController.text,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text(
                        "Priority",
                        style: textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: items,
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      widget.id.isEmpty || isEdit
                          ? InkWell(
                              child: AbsorbPointer(
                                child: TextField(
                                  enabled: widget.id.isEmpty || isEdit,
                                  style: textTheme.title,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    labelText: widget.id.isEmpty || isEdit
                                        ? "Response Date"
                                        : "",
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                        fontSize: 18),
                                    border: widget.id.isEmpty || isEdit
                                        ? null
                                        : InputBorder.none,
                                  ),
                                  controller: _responseDateController,
                                ),
                              ),
                              onTap: () async {
                                if (widget.id.isEmpty || isEdit) {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    firstDate:  DateTime(1953),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2035),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      bandComm.responseDate =
                                          picked.millisecondsSinceEpoch;
                                      _responseDateController.text =
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
                          : Text(
                              _responseDateController.text,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
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
                      (widget.id.isNotEmpty && !isEdit) &&
                              !(bandComm?.isArchieve ?? false)
                          ? (bandComm != null ? bandComm.userId : false) ==
                                  presenter.serverAPI.currentUserId
                              ? RaisedButton(
                                  child: Text("Archive Commnuication"),
                                  color: Color.fromRGBO(214, 22, 35, 1.0),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    bandComm.isArchieve = true;
                                    presenter.addBandComm(bandComm);
                                  },
                                )
                              : Container()
                          : Container(),
                      Padding(padding: EdgeInsets.all(20)),
                      (widget.id.isNotEmpty && !isEdit) &&
                              (widget.isLeader &&
                                  bandComm?.userId !=
                                      presenter.serverAPI.currentUserId)
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                  color: Color.fromRGBO(214, 22, 35, 1.0),
                                  textColor: Colors.white,
                                  child: Text("Approved"),
                                  onPressed: () {
                                    bandComm.status =
                                        BandCommunication.STATUS_APPROVED;
                                    presenter.addBandComm(bandComm);
                                  },
                                )),
                                Padding(padding: EdgeInsets.all(5)),
                                Expanded(
                                    child: RaisedButton(
                                  textColor: Color.fromRGBO(214, 22, 35, 1.0),
                                  color: Colors.white,
                                  child: Text("Declined"),
                                  onPressed: () {
                                    bandComm.status =
                                        BandCommunication.STATUS_DECLINED;
                                    presenter.addBandComm(bandComm);
                                  },
                                )),
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

  @override
  AddBandCommPresenter get presenter => AddBandCommPresenter(this);

  @override
  void onSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created Successfully");
    Navigator.of(context).pop();
  }

  @override
  void onUpdate() {
    showMessage("Updated Successfully");
    setState(() {
      isEdit = false;
    });
    presenter.getBandCommDetails(widget.id);
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
        presenter.getBandCommDetails(widget.id);
      });
    } else {
      bandComm = BandCommunication();
      bandComm.bandId = widget.bandId;
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
                  presenter.deleteBandComm(widget.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
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
    String desc = _addCommController.text;
    String note = _titleController.text;

    setState(() {
      _descError = null;
      _startDateError = null;
      if (note.isEmpty) {
        _titleError = "Cannot be Empty";
      } else if (desc.isEmpty) {
        _descError = "Cannot be Empty";
      } else {
        showLoading();
        presenter.addBandComm(bandComm);
      }
    });
  }

  @override
  void onStatusUpdate() {
    presenter.getBandCommDetails(widget.id);
  }

  @override
  void getBandCommDetails(BandCommunication note) {
    hideLoading();
    setState(() {
      bandComm = note;
      _addCommController.text = bandComm.addCommunication;
      _titleController.text = "${bandComm.title}";
    });
  }
}
