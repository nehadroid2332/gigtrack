import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
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

  List<Band> myBands = [];

  @override
  void initState() {
    super.initState();
    presenter.getBands();
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
    List<SpeedDialChild> items = [
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
        label: "Appointment",
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
        onTap: () async {
          showDialogConfirm();
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
    ];

    if (widget.bandId.isEmpty) {
      items.add(SpeedDialChild(
        label: "Task",
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
        onTap: () async {
          await widget.appListener.router.navigateTo(
              context,
              Screens.ADDACTIVITY.toString() +
                  "/${Activites.TYPE_TASK}///${widget.bandId}////");
        },
      ));
    } else if (widget.bandId.isNotEmpty) {
      items.add(SpeedDialChild(
        label: "Band Task",
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(32, 95, 139, 1.0),
        onTap: () async {
          await widget.appListener.router.navigateTo(
              context,
              Screens.ADDACTIVITY.toString() +
                  "/${Activites.TYPE_BAND_TASK}///${widget.bandId}////");
        },
      ));
    }

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
                  List<Activites> recurring = [];
                  List<Activites> bandActivities = [];

                  DateTime currentDate = DateTime.now().toLocal();
                  for (var ac in activities) {
                    DateTime startDate =
                        DateTime.fromMillisecondsSinceEpoch(ac.startDate)
                            .toLocal();
                    DateTime endDate;
                    if (ac.endDate != 0) {
                      endDate = DateTime.fromMillisecondsSinceEpoch(ac.endDate)
                          .toLocal();
                    }
                    int days = currentDate.difference(startDate).inDays;
                    int days2;
                    if (endDate != null) {
                      days2 = currentDate.difference(endDate).inDays;
                    }
                    bool check = myBands.any((a) {
                      return a.id == ac.bandId;
                    });
                    if (check) {
                      bandActivities.add(ac);
                    } else if (ac.isRecurring) {
                      recurring.add(ac);
                    } else if (days == 0 || (days2 != null && days2 == 0)) {
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
                      //  past =  past.sort((b, a) => a.compareTo(b));
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
                  current.sort((a, b) => a.startDate.compareTo(b.startDate));
                  current.sort((a, b) {
                    DateTime aD =
                        DateTime.fromMillisecondsSinceEpoch(a.startDate);
                    DateTime bD =
                        DateTime.fromMillisecondsSinceEpoch(b.startDate);
                    if (aD.day == bD.day && aD.month == bD.month) {
                      return a.title.compareTo(b.title);
                    }
                    return 0;
                  });

                  upcoming.sort((a, b) => a.startDate.compareTo(b.startDate));
                  upcoming.sort((a, b) {
                    DateTime aD =
                        DateTime.fromMillisecondsSinceEpoch(a.startDate);
                    DateTime bD =
                        DateTime.fromMillisecondsSinceEpoch(b.startDate);
                    if (aD.day == bD.day && aD.month == bD.month) {
                      return a.title.compareTo(b.title);
                    }
                    return 0;
                  });

                  recurring.sort((a, b) => a.startDate.compareTo(b.startDate));
                  recurring.sort((a, b) {
                    DateTime aD =
                        DateTime.fromMillisecondsSinceEpoch(a.startDate)
                            .toLocal();
                    DateTime bD =
                        DateTime.fromMillisecondsSinceEpoch(b.startDate)
                            .toLocal();
                    if (aD.day == bD.day && aD.month == bD.month) {
                      return a.title.compareTo(b.title);
                    }
                    return 0;
                  });

                  past.sort((a, b) =>
                      a.taskCompleteDate ??
                      0.compareTo(b.taskCompleteDate ?? 0));

                  return ListView(
                    children: <Widget>[
                      Text(
                        "Today",
                        style: textTheme.display1.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      current.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 10),
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
                          : Padding(
                              child: Center(
                                child: Text("No Current Activities"),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                      Text(
                        "Upcoming",
                        style: textTheme.display1.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      upcoming.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 10),
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
                          : Padding(
                              child: Center(
                                child: Text("No Upcoming Activities"),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                      Text(
                        "Past",
                        style: textTheme.display1.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      past.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10),
                              itemCount: past.length,
                              itemBuilder: (BuildContext context, int index) {
                                Activites ac = past[index];
                                return buildActivityListItem(ac, onTap: () {
                                  widget.appListener.router.navigateTo(
                                    context,
                                    Screens.ADDACTIVITY.toString() +
                                        "/${ac.type}/${ac.id}/${false}/${widget.bandId}////",
                                  );
                                },
                                    isPast: (ac.type == Activites.TYPE_TASK &&
                                        (past[index].taskCompleteDate != null
                                                ? ac.taskCompleteDate
                                                : 0) <
                                            currentDate
                                                .millisecondsSinceEpoch));
                              },
                            )
                          : Padding(
                              child: Center(
                                child: Text("No Past Activities"),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                      Text(
                        "Recurring",
                        style: textTheme.display1.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      recurring.length > 0
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: recurring.length,
                              itemBuilder: (BuildContext context, int index) {
                                Activites ac = recurring[index];
                                return buildActivityListItem(ac, onTap: () {
                                  widget.appListener.router.navigateTo(
                                    context,
                                    Screens.ADDACTIVITY.toString() +
                                        "/${ac.type}/${ac.id}/${false}/${widget.bandId}////",
                                  );
                                }, isPast: false);
                              },
                            )
                          : Padding(
                              child: Center(
                                child: Text("No Recurring Activities"),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                      // widget.bandId.isEmpty
                      //     ? Text(
                      //         "Band Activities",
                      //         style: textTheme.display1.copyWith(fontSize: 28),
                      //         textAlign: TextAlign.center,
                      //       )
                      //     : Container(),
                      // widget.bandId.isEmpty
                      //     ? bandActivities.length > 0
                      //         ? ListView.builder(
                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             itemCount: bandActivities.length,
                      //             itemBuilder:
                      //                 (BuildContext context, int index) {
                      //               Activites ac = bandActivities[index];
                      //               return buildActivityListItem(ac, onTap: () {
                      //                 widget.appListener.router.navigateTo(
                      //                   context,
                      //                   Screens.ADDACTIVITY.toString() +
                      //                       "/${ac.type}/${ac.id}/${false}/${widget.bandId}////",
                      //                 );
                      //               }, isPast: false);
                      //             },
                      //           )
                      //         : Padding(
                      //             child: Center(
                      //               child: Text("No Band Activities"),
                      //             ),
                      //             padding: EdgeInsets.symmetric(vertical: 10),
                      //           )
                      //     : Container()
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
                  children: items,
                )
              : Container(),
    );
  }

  showDialogConfirm() {
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
            "Information!",
            textAlign: TextAlign.center,
          ),
          content: Text("Release date would be coming soon..."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new RaisedButton(
              child: new Text(
                "Dismiss",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(32, 95, 139, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  ActivitiesListPresenter get presenter => ActivitiesListPresenter(this);

  @override
  void getBands(List<Band> acc) {
    setState(() {
      myBands = acc;
    });
  }
}
