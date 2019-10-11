import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class ActivitiesListScreen extends BaseScreen {
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;
  ActivitiesListScreen(
    AppListener appListener, {
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "Activities");

  @override
  _ActivitiesListScreenState createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState
    extends BaseScreenState<ActivitiesListScreen, ActivitiesListPresenter>
    implements ActivitiesListContract {
  List<Activites> activities = <Activites>[];
  Stream<List<Activites>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getList(widget.bandId);
  }

  @override
  AppBar get appBar => AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.appListener.primaryColorDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

  // final _pageController = PageController();

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/activities_red.png',
                  height: 40,
                  width: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Activities",
                  style: textTheme.display1.copyWith(
                      color: widget.appListener.primaryColorDark, fontSize: 28),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            Expanded(
              child: StreamBuilder<List<Activites>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    activities = snapshot.data;
                  }
                  List<Activites> current = [];
                  List<Activites> upcoming = [];
                  List<Activites> past = [];
                  DateTime currentDate = DateTime.now();
                  for (var ac in activities) {
                    DateTime startDate =
                        DateTime.fromMillisecondsSinceEpoch(ac.startDate);
                    DateTime endDate;
                    if (ac.endDate != 0) {
                      endDate = DateTime.fromMillisecondsSinceEpoch(ac.endDate);
                    }
                    int days = currentDate.difference(startDate).inDays;
                    int days2;
                    if (endDate != null) {
                      days2 = currentDate.difference(endDate).inDays;
                    }
                    if (days == 0 || (days2 != null && days2 == 0)) {
                      current.add(ac);
                    } else if (days.isNegative) {
                      upcoming.add(ac);
                    } else if (!days.isNegative) {
                      if (days2 != null) {
                        if (days2.isNegative) {
                          current.add(ac);
                        } else {
                          past.add(ac);
                        }
                      } else {
                        past.add(ac);
                      }
                    }
                    // if (currentDate >= startDate &&
                    //     currentDate <= (endDate ?? 0)) {
                    //   current.add(ac);
                    // } else if (currentDate > (endDate ?? 0) ||
                    //     currentDate > startDate) {
                    //   past.add(ac);
                    // } else if (currentDate < startDate) {
                    //   upcoming.add(ac);
                    // }
                  }

                  return ListView(
                    children: <Widget>[
                      RaisedButton(
                        color: Color.fromRGBO(32, 95, 139, 1.0),
                        textColor: Colors.white,
                        onPressed: () {},
                        child: Text("Today"),
                      ),
                      current.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: current.length,
                              itemBuilder: (BuildContext context, int index) {
                                Activites ac = current[index];
                                return buildActivityListItem(ac, onTap: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDACTIVITY.toString() +
                                          "/${ac.type}/${ac.id}/${false}/${widget.bandId}////");
                                });
                              },
                            )
                          : Center(
                              child: Text("No Current Activities"),
                            ),
                      RaisedButton(
                        color: Color.fromRGBO(32, 95, 139, 1.0),
                        textColor: Colors.white,
                        onPressed: () {},
                        child: Text("Upcoming"),
                      ),
                      upcoming.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: upcoming.length,
                              itemBuilder: (BuildContext context, int index) {
                                Activites ac = upcoming[index];
                                return buildActivityListItem(ac, onTap: () {
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDACTIVITY.toString() +
                                          "/${ac.type}/${ac.id}/${false}/${widget.bandId}////");
                                });
                              },
                            )
                          : Center(
                              child: Text("No Upcoming Activities"),
                            ),
                      RaisedButton(
                        color: Color.fromRGBO(32, 95, 139, 1.0),
                        textColor: Colors.white,
                        onPressed: () {},
                        child: Text("Past"),
                      ),
                      past.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: past.length,
                              itemBuilder: (BuildContext context, int index) {
                                Activites ac = past[index];
                                return buildActivityListItem(ac, onTap: () {
                                  widget.appListener.router.navigateTo(
                                    context,
                                    Screens.ADDACTIVITY.toString() +
                                        "/${ac.type}/${ac.id}/${false}/${widget.bandId}////",
                                  );
                                }, isPast: true);
                              },
                            )
                          : Center(
                              child: Text("No Past Activities"),
                            )
                    ],
                  );

                  // return Column(
                  //   children: <Widget>[
                  //     Row(
                  //       children: <Widget>[
                  //         Expanded(
                  //           child: RaisedButton(
                  //             color: Color.fromRGBO(32, 95, 139, 1.0),
                  //             textColor: Colors.white,
                  //             onPressed: () {
                  //               _pageController.animateToPage(
                  //                 0,
                  //                 curve: Curves.easeIn,
                  //                 duration: Duration(milliseconds: 450),
                  //               );
                  //             },
                  //             child: Text("Current"),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.all(1),
                  //         ),
                  //         Expanded(
                  //           child: RaisedButton(
                  //             textColor: Colors.white,
                  //             color: Color.fromRGBO(32, 95, 139, 1.0),
                  //             onPressed: () {
                  //               _pageController.animateToPage(
                  //                 1,
                  //                 curve: Curves.easeIn,
                  //                 duration: Duration(milliseconds: 450),
                  //               );
                  //             },
                  //             child: Text("Upcoming"),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.all(1),
                  //         ),
                  //         Expanded(
                  //           child: RaisedButton(
                  //             textColor: Colors.white,
                  //             color: Color.fromRGBO(32, 95, 139, 1.0),
                  //             onPressed: () {
                  //               _pageController.animateToPage(
                  //                 2,
                  //                 curve: Curves.easeIn,
                  //                 duration: Duration(milliseconds: 450),
                  //               );
                  //             },
                  //             child: Text("Past"),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     // Expanded(
                  //     //   child: PageView.builder(
                  //     //     controller: _pageController,
                  //     //     itemBuilder: (BuildContext context, int index) {
                  //     //       return Column(
                  //     //         children: <Widget>[
                  //     //           Row(
                  //     //             children: <Widget>[
                  //     //               Expanded(
                  //     //                 child: Container(
                  //     //                   width: double.infinity,
                  //     //                   color: index == 0
                  //     //                       ? Colors.red
                  //     //                       : Colors.white,
                  //     //                   height: 1,
                  //     //                 ),
                  //     //               ),
                  //     //               Expanded(
                  //     //                 child: Container(
                  //     //                   width: double.infinity,
                  //     //                   color: index == 1
                  //     //                       ? Colors.red
                  //     //                       : Colors.white,
                  //     //                   height: 1,
                  //     //                 ),
                  //     //               ),
                  //     //               Expanded(
                  //     //                 child: Container(
                  //     //                   width: double.infinity,
                  //     //                   color: index == 2
                  //     //                       ? Colors.red
                  //     //                       : Colors.white,
                  //     //                   height: 1,
                  //     //                 ),
                  //     //               )
                  //     //             ],
                  //     //           ),
                  //     //           Expanded(
                  //     //             child: ListView.builder(
                  //     //               padding: EdgeInsets.only(
                  //     //                 bottom: 60,
                  //     //               ),
                  //     //               itemBuilder:
                  //     //                   (BuildContext context, int index1) {
                  //     //                 Activites ac = index == 0
                  //     //                     ? current[index1]
                  //     //                     : index == 1
                  //     //                         ? upcoming[index1]
                  //     //                         : index == 2
                  //     //                             ? past[index1]
                  //     //                             : null;
                  //     //                 return buildActivityListItem(ac,
                  //     //                     onTap: () {
                  //     //                   widget.appListener.router.navigateTo(
                  //     //                       context,
                  //     //                       Screens.ADDACTIVITY.toString() +
                  //     //                           "/${ac.type}/${ac.id}/${false}");
                  //     //                 });
                  //     //               },
                  //     //               itemCount: index == 0
                  //     //                   ? current.length
                  //     //                   : index == 1
                  //     //                       ? upcoming.length
                  //     //                       : index == 2 ? past.length : 0,
                  //     //             ),
                  //     //           )
                  //     //         ],
                  //     //       );
                  //     //     },
                  //     //   ),
                  //     // )
                  //   ],
                  // );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton:
          widget.bandId.isEmpty || (widget.bandId != null && widget.isLeader)
              ? SpeedDial(
                  animatedIcon: AnimatedIcons.menu_close,
                  backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
                  children: [
                    SpeedDialChild(
                      label: "Activities",
                      child: Icon(Icons.add),
                      backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
                      onTap: () async {
                        await widget.appListener.router.navigateTo(
                            context,
                            Screens.ADDACTIVITY.toString() +
                                "/${Activites.TYPE_ACTIVITY}///${widget.bandId}////");
                      },
                    ),
                    SpeedDialChild(
                      label: "Performance Schedule",
                      child: Icon(Icons.add),
                      backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
                      onTap: () async {
                        await widget.appListener.router.navigateTo(
                            context,
                            Screens.ADDACTIVITY.toString() +
                                "/${Activites.TYPE_PERFORMANCE_SCHEDULE}///${widget.bandId}////");
                      },
                    ),
                    SpeedDialChild(
                      label: "Practice Schedule",
                      backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
                      child: Icon(Icons.add),
                      onTap: () async {
                        await widget.appListener.router.navigateTo(
                            context,
                            Screens.ADDACTIVITY.toString() +
                                "/${Activites.TYPE_PRACTICE_SCHEDULE}///${widget.bandId}////");
                      },
                    ),
                    SpeedDialChild(
                      label: "Task",
                      child: Icon(Icons.add),
                      backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
                      onTap: () async {
                        await widget.appListener.router.navigateTo(
                            context,
                            Screens.ADDACTIVITY.toString() +
                                "/${Activites.TYPE_TASK}///${widget.bandId}////");
                      },
                    )
                  ],
                )
              : Container(),
    );
  }

  @override
  ActivitiesListPresenter get presenter => ActivitiesListPresenter(this);
}
