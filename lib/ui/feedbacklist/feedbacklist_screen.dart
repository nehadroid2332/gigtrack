import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/server/models/feedback.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import '../../main.dart';
import 'feedbacklist_presenter.dart';

class FeedbackListScreen extends BaseScreen {
  FeedbackListScreen(AppListener appListener) : super(appListener);

  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState
    extends BaseScreenState<FeedbackListScreen, FeedbackListPresenter> {
  List<UserFeedback> _notes = <UserFeedback>[];

  Stream<List<UserFeedback>> list;

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
                  "Feedback List",
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
              child: StreamBuilder<List<UserFeedback>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _notes = snapshot.data;
                    return ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final feedback = _notes[index];
                        return Container(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "${feedback.message}",
                                    style: textTheme.subhead,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${feedback.user?.firstName}",
                                      style: textTheme.caption,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
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
    );
  }

  @override
  FeedbackListPresenter get presenter => FeedbackListPresenter(this);
}
