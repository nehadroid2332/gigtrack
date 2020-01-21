import 'package:flutter/material.dart';
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
                  "Payment List",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.appListener.router
              .navigateTo(context, Screens.ADD_PAYMENT.toString() + "/");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  PaymentListPresenter get presenter => PaymentListPresenter(this);
}
