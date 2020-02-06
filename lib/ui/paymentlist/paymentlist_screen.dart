import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/server/models/payment.dart';
import 'package:gigtrack/ui/paymentlist/paymentlist_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import '../../main.dart';

class PaymentListScreen extends BaseScreen {
  PaymentListScreen(AppListener appListener) : super(appListener);

  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState
    extends BaseScreenState<PaymentListScreen, PaymentListPresenter> {
  List<Payment> _notes = <Payment>[];

  Stream<List<Payment>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getList();
  }

  @override
  AppBar get appBar => AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(214, 22, 35, 1.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

  @override
  Widget buildBody() {
    List<SpeedDialChild> items = [
      SpeedDialChild(
        label: "Money Received",
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        onTap: () async {
          widget.appListener.router.navigateTo(context,
              Screens.ADD_PAYMENT.toString() + "//${Payment.TYPE_RECIEVE}");
        },
      ),
      SpeedDialChild(
        label: "Money Paid Out",
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        onTap: () async {
          widget.appListener.router.navigateTo(context,
              Screens.ADD_PAYMENT.toString() + "//${Payment.TYPE_PAID}");
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                new SvgPicture.asset(
                  'assets/images/finalbulletin.svg',
                  height: 40.0,
                  width: 40.0,
                  //allowDrawingOutsideViewBox: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Finance List",
                  style: textTheme.display1.copyWith(
                      color: Color.fromRGBO(214, 22, 35, 1.0),
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: StreamBuilder<List<Payment>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _notes = snapshot.data;
                    return ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final feedback = _notes[index];
                        return InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "${feedback.amount}",
                                    style: textTheme.subhead,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${feedback.type == Payment.TYPE_PAID ? 'Paid' : feedback.type == Payment.TYPE_RECIEVE ? 'Receive' : ''}",
                                      style: textTheme.caption,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            widget.appListener.router.navigateTo(
                                context,
                                Screens.ADD_PAYMENT.toString() +
                                    "/${feedback.id}");
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error Occured"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: AppProgressWidget(),
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        overlayColor: Colors.white,
        overlayOpacity: 1.0,
        children: items,
      ),
    );
  }

  @override
  PaymentListPresenter get presenter => PaymentListPresenter(this);
}
