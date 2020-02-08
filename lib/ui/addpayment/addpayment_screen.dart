import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/payment.dart';
import 'package:gigtrack/ui/addpayment/addpayment_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddPaymentScreen extends BaseScreen {
  final String id;
  final String type;

  AddPaymentScreen(AppListener appListener, {this.id, this.type})
      : super(appListener, title: "");

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState
    extends BaseScreenState<AddPaymentScreen, AddPaymentPresenter>
    implements AddPaymentContract {
  final _notesController = TextEditingController(),
      _amountController = TextEditingController(),
      _startDateController = TextEditingController();

  String _descError, _startDateError, _noteError;

  @override
  void initState() {
    super.initState();
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
                : MediaQuery.of(context).size.width / 2,
            child: Text(
              "${widget.id.isEmpty ?payment.type == Payment.TYPE_PAID ?"Money Paid out":"Money Received":""}",
              textAlign: TextAlign.center,
              style: textTheme.headline.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          widget.id.isEmpty
              ? Container()
              : Container(
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
                ),
          widget.id.isEmpty
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

  Payment payment;

  final paymentStatus = <String>["Today", "Not yet", "Another Date"];
  List<String> paymentPurposes = <String>[];

  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Image Picker"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Camera"),
              onPressed: () async {
                Navigator.of(context).pop();
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  payment.image = image.path;
                });
              },
            ),
            new FlatButton(
              child: new Text("Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  payment.image = image.path;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildBody() {
    if (payment.type == Payment.TYPE_PAID) {
      paymentPurposes = <String>[
        "Buy Equipment",
        "Day-to-Day Expenses",
        "Loan Payment"
      ];
    } else if (payment.type == Payment.TYPE_RECIEVE) {
      paymentPurposes = <String>[
        "Payroll",
        "Performance",
        "Loan",
        "Gift",
        "Other"
      ];
    }

    List<Widget> items = [];
    for (String s in paymentStatus) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: payment.paymentStatus == s
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: payment.paymentStatus == s
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
                  payment.paymentStatus = s;
                });
              }
            : null,
      ));
    }
    List<Widget> items2 = [];
    for (String s in paymentPurposes) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: payment.paymentPurpose == s
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: payment.paymentPurpose == s
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
                  payment.paymentPurpose = s;
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
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                            width: 110.0,
                            height: 110.0,
                            decoration: payment.image != null
                                ? new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: (payment.image != null &&
                                              !File(payment.image).existsSync())
                                          ? NetworkImage(payment.image)
                                          : FileImage(File(payment.image)),
                                    ),
                                  )
                                : null,
                            child: payment.image == null &&
                                    (payment.image == null ||
                                        payment.image.isEmpty)
                                ? Icon(
                                    Icons.camera,
                                    size: 130,
                                  )
                                : null,
                          ),
                          onTap: isEdit || widget.id.isEmpty ? getImage : null,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Text(
                          "Take a picture of invoice",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
//                      Text(
//                          "${payment.type == Payment.TYPE_PAID ? 'Paid' : payment.type == Payment.TYPE_RECIEVE ? 'Received' : ''} Select Type"),
//                      Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: RaisedButton(
//                              child: Text("Paid"),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(20),
//                              ),
//                              color: payment.type == Payment.TYPE_PAID
//                                  ? Color.fromRGBO(214, 22, 35, 1.0)
//                                  : Colors.white,
//                              textColor: payment.type == Payment.TYPE_PAID
//                                  ? Colors.white
//                                  : Color.fromRGBO(214, 22, 35, 1.0),
//                              onPressed: () {
//                                // if (widget.id.isEmpty || isEdit)
//                                //   setState(() {
//                                //     payment.type = Payment.TYPE_PAID;
//                                //   });
//                              },
//                            ),
//                          ),
//                          Padding(
//                            padding: EdgeInsets.all(5),
//                          ),
//                          Expanded(
//                            child: RaisedButton(
//                              child: Text("Recieve"),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(20),
//                              ),
//                              color: payment.type == Payment.TYPE_RECIEVE
//                                  ? Color.fromRGBO(214, 22, 35, 1.0)
//                                  : Colors.white,
//                              textColor: payment.type == Payment.TYPE_RECIEVE
//                                  ? Colors.white
//                                  : Color.fromRGBO(214, 22, 35, 1.0),
//                              onPressed: () {
//                                // if (widget.id.isEmpty || isEdit)
//                                //   setState(() {
//                                //     payment.type = Payment.TYPE_RECIEVE;
//                                //   });
//                              },
//                            ),
//                          )
//                        ],
//                      ),
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
                                    ? "Enter Dollar Amount"
                                    : "",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              onChanged: (a) {
                                payment.amount = a;
                              },
                              controller: _amountController,
                            )
                          : Text(
                              _amountController.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        payment.type == Payment.TYPE_PAID
                            ? "When was this paid made?"
                            : payment.type == Payment.TYPE_RECIEVE
                                ? "When was this amount received?"
                                : "",
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
                          : payment.paymentStatus.isNotEmpty
                              ? Text(
                                  payment.paymentStatus,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        payment.type == Payment.TYPE_PAID
                            ? "What is payment for?"
                            : payment.type == Payment.TYPE_RECIEVE
                                ? "What was deposit received for?"
                                : "",
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
                              children: items2,
                            )
                          : payment.paymentPurpose.isNotEmpty
                              ? Text(
                                  payment.paymentPurpose,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                )
                              : Container(),
                      widget.id.isNotEmpty
                          ? Text(
                              isEdit
                                  ? ""
                                  : payment.type == Payment.TYPE_PAID
                                      ? "Money payment Notes"
                                      : "Money Received Notes",
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
                                    ? "Money ${payment.type == Payment.TYPE_PAID ? 'Paid' : payment.type == Payment.TYPE_RECIEVE ? 'Received' : ''} Notes"
                                    : "",
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(202, 208, 215, 1.0),
                                    fontSize: 18),
                                border: widget.id.isEmpty || isEdit
                                    ? null
                                    : InputBorder.none,
                              ),
                              onChanged: (a) {
                                payment.notes = a;
                              },
                              controller: _notesController,
                            )
                          : Text(
                              _notesController.text,
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
  AddPaymentPresenter get presenter => AddPaymentPresenter(this);

  @override
  void onSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created Successfully");
    Navigator.of(context).pop();
  }

  @override
  void getBulletInBoardDetails(Payment note) {
    hideLoading();
    setState(() {
      payment = note;
      _notesController.text = payment.notes;
      _amountController.text = "\$${payment.amount}";
    });
  }

  @override
  void onUpdate() {
    showMessage("Updated Successfully");
    setState(() {
      isEdit = !isEdit;
    });
    presenter.getPaymentDetails(widget.id);
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
        presenter.getPaymentDetails(widget.id);
      });
    } else {
      payment = Payment();
      if (widget.type == "${Payment.TYPE_PAID}") {
        payment.type = Payment.TYPE_PAID;
      } else if (widget.type == "${Payment.TYPE_RECIEVE}") {
        payment.type = Payment.TYPE_RECIEVE;
      }
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
                  presenter.deletePayment(widget.id);
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
    if (payment.type == null) {
      showMessage("Please Select Type");
      return;
    }
    String desc = _notesController.text;
    String note = _amountController.text;

    setState(() {
      _descError = null;
      _startDateError = null;
      if (desc.isEmpty) {
        _descError = "Cannot be Empty";
      } else {
        showLoading();
        presenter.addPayment(payment);
      }
    });
  }

  @override
  void onStatusUpdate() {
    presenter.getPaymentDetails(widget.id);
  }
}
