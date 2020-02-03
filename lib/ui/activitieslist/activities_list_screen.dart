import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ActivitiesListScreen extends BaseScreen {
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;
  final int type;

  ActivitiesListScreen(
    AppListener appListener, {
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
    this.type,
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
  bool isArchive = false;
  bool isRecurring = false;
  String bandName;

  @override
  void initState() {
    super.initState();
    presenter.getBands(widget.bandId);

    list = presenter.getList(widget.bandId, widget.type);
  }

  @override
  AppBar get appBar => AppBar(
        brightness: Brightness.light,
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
        title: Text(
          "${bandName ?? ""}",
          style: textTheme.title.copyWith(
            color: Colors.blueAccent,
          ),
        ),
      );

//Today
//this Week
//this month
  // final _pageController = PageController();

  @override
  Widget buildBody() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blue, // Color for Android
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor:
            Colors.white // Dark == white status bar -- for IOS.
        ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(99, 97, 93, .5),
    ));
    List<SpeedDialChild> items = [
      SpeedDialChild(
        label: "Activities",
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        onTap: () async {
          await widget.appListener.router.navigateTo(
              context,
              Screens.ADDACTIVITY.toString() +
                  "/${Activites.TYPE_ACTIVITY}///${widget.bandId}////");
        },
      ),
      SpeedDialChild(
        label: "Appointment",
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        onTap: () async {
          //showDialogConfirm();
          await widget.appListener.router.navigateTo(
              context,
              Screens.ADDACTIVITY.toString() +
                  "/${Activites.TYPE_APPOINTMENT}///${widget.bandId}////");
        },
      ),
      SpeedDialChild(
        label: "Performance Schedule",
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        onTap: () async {
          await widget.appListener.router.navigateTo(
              context,
              Screens.ADDACTIVITY.toString() +
                  "/${Activites.TYPE_PERFORMANCE_SCHEDULE}///${widget.bandId}////");
        },
      ),
      SpeedDialChild(
        label: "Practice Schedule",
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
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
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
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
        labelStyle: TextStyle(color: Color.fromRGBO(45, 1, 79, 1.0)),
        backgroundColor: Color.fromRGBO(40, 35, 188, 1.0),
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
//                Image.asset(
//                  'assets/images/activities_red.png',
//                  height: 40,
//                  width: 40,
//                ),
                new SvgPicture.asset(
                  'assets/images/finalcalander.svg',
                  height: 40.0,
                  width: 40.0,
                  //allowDrawingOutsideViewBox: true,
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

                    List<Activites> current = [];
                    List<Activites> upcoming = [];
                    List<Activites> past = [];
                    List<Activites> recurring = [];
                    List<Activites> afterWeek = [];

                    DateTime currentDate = DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 0, 0, 0)
                        .toLocal();
                    for (var ac in activities) {
                      DateTime startDate =
                          DateTime.fromMillisecondsSinceEpoch(ac.startDate)
                              .toLocal();
                      DateTime endDate;
                      if (ac.endDate != 0) {
                        endDate =
                            DateTime.fromMillisecondsSinceEpoch(ac.endDate)
                                .toLocal();
                      }
                      DateTime st = DateTime(startDate.year, startDate.month,
                          startDate.day, 0, 0, 0);

                      int days = st.difference(currentDate).inDays;
                      int days2;
                      if (endDate != null) {
                        days2 = currentDate.difference(endDate).inDays;
                      }
                      bool currentWeek = false;
                      bool afterweek = false;
                      if (!days.isNegative) {
                        switch (currentDate.weekday) {
                          case 1:
                            if (days.abs() <= 7) {
                              currentWeek = true;
                            }
                            break;
                          case 2:
                            if (days.abs() <= 6) {
                              currentWeek = true;
                            }
                            break;
                          case 3:
                            if (days.abs() <= 5) {
                              currentWeek = true;
                            }
                            break;
                          case 4:
                            if (days.abs() <= 4) {
                              currentWeek = true;
                            }
                            break;
                          case 5:
                            if (days.abs() <= 2) {
                              currentWeek = true;
                            } else if (days.abs() > 2) {
                              afterweek = true;
                            }
                            break;
                          case 6:
                            if (days.abs() <= 2) {
                              currentWeek = true;
                            }
                            break;
                          case 7:
                            if (days.abs() <= 1) {
                              currentWeek = true;
                            }
                            break;
                          default:
                        }
                      }

                      if (ac.isRecurring) {
                        recurring.add(ac);
                      } else if (days == 0) {
                        current.add(ac);
                      } else if (currentWeek) {
                        upcoming.add(ac);
                      } else if (days.isNegative) {
                        if (days2 != null) {
                          if (days2.isNegative) {
                            // current.add(ac);
                          } else {
                            past.add(ac);
                          }
                        } else {
                          past.add(ac);
                        }
                      } else if (afterweek) {
                        afterWeek.add(ac);
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

                    afterWeek
                        .sort((a, b) => a.startDate.compareTo(b.startDate));
                    afterWeek.sort((a, b) {
                      DateTime aD =
                          DateTime.fromMillisecondsSinceEpoch(a.startDate);
                      DateTime bD =
                          DateTime.fromMillisecondsSinceEpoch(b.startDate);
                      if (aD.day == bD.day && aD.month == bD.month) {
                        return a.title.compareTo(b.title);
                      }
                      return 0;
                    });

                    recurring
                        .sort((a, b) => a.startDate.compareTo(b.startDate));
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

                    Map<int, List<Activites>> currentDates = Map();
                    for (var c in current) {
                      List<Activites> list;
                      if (currentDates.containsKey(c.startDate)) {
                        list = currentDates[c.startDate];
                      } else {
                        list = [];
                      }
                      list.add(c);
                      currentDates[c.startDate] = list;
                    }

                    Map<int, List<Activites>> upcomingDates = Map();
                    for (var c in upcoming) {
                      List<Activites> list;
                      if (upcomingDates.containsKey(c.startDate)) {
                        list = upcomingDates[c.startDate];
                      } else {
                        list = [];
                      }
                      list.add(c);
                      upcomingDates[c.startDate] = list;
                    }

                    Map<int, List<Activites>> afterWeekDates = Map();
                    for (var c in afterWeek) {
                      List<Activites> list;
                      if (afterWeekDates.containsKey(c.startDate)) {
                        list = afterWeekDates[c.startDate];
                      } else {
                        list = [];
                      }
                      list.add(c);
                      afterWeekDates[c.startDate] = list;
                    }
                    Map<int, List<Activites>> recurringDates = Map();
                    for (var c in recurring) {
                      List<Activites> list;
                      if (recurringDates.containsKey(c.startDate)) {
                        list = recurringDates[c.startDate];
                      } else {
                        list = [];
                      }
                      list.add(c);
                      recurringDates[c.startDate] = list;
                    }
                    Map<int, List<Activites>> pastDates = Map();
                    for (var c in past) {
                      List<Activites> list;
                      if (pastDates.containsKey(c.startDate)) {
                        list = pastDates[c.startDate];
                      } else {
                        list = [];
                      }
                      list.add(c);
                      pastDates[c.startDate] = list;
                    }
                    return ListView(
                      children: <Widget>[
                        StickyHeader(
                          header: Container(
                            child: Text(
                              "Today",
                              style: textTheme.display1.copyWith(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            padding: EdgeInsets.all(5),
                            color: Colors.blueAccent,
                            width: double.infinity,
                          ),
                          content: current.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  itemCount: currentDates.keys.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int ac = currentDates.keys.elementAt(index);
                                    List<Activites> accs = currentDates[ac];
                                    DateTime dt =
                                        DateTime.fromMillisecondsSinceEpoch(ac)
                                            .toLocal();
                                    return Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              color: Colors.grey,
                                              width: 1.2,
                                              height: 50,
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              child: Text(
                                                "${formatDate(dt, [
                                                  DD,
                                                  '\n',
                                                  mm,
                                                  '/',
                                                  dd,
                                                  '/',
                                                  yy,
                                                ])}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1.2,
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: accs.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Activites ac = accs[index];
                                              return buildActivityListItem(
                                                ac,
                                                context,
                                                onTap: () {
                                                  widget.appListener.router
                                                      .navigateTo(
                                                          context,
                                                          Screens.ADDACTIVITY
                                                                  .toString() +
                                                              "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////");
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Padding(
                                  child: Center(
                                    child: Text("No Current Activities"),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                        ),
                        StickyHeader(
                          header: Container(
                            child: Text(
                              "This Week",
                              style: textTheme.display1
                                  .copyWith(fontSize: 23, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                            color: Colors.blueAccent,
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                          ),
                          content: upcoming.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  itemCount: upcomingDates.keys.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int ac =
                                        upcomingDates.keys.elementAt(index);
                                    List<Activites> accs = upcomingDates[ac];
                                    DateTime dt =
                                        DateTime.fromMillisecondsSinceEpoch(ac)
                                            .toLocal();
                                    return Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              color: Colors.grey,
                                              width: 1.2,
                                              height: 50,
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  7,
                                              child: Text(
                                                "${formatDate(dt, [
                                                  DD,
                                                  '\n',
                                                  mm,
                                                  '/',
                                                  dd,
                                                  '/',
                                                  yy,
                                                ])}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1.2,
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: accs.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Activites ac = accs[index];
                                              return buildActivityListItem(
                                                ac,
                                                context,
                                                onTap: () {
                                                  widget.appListener.router
                                                      .navigateTo(
                                                          context,
                                                          Screens.ADDACTIVITY
                                                                  .toString() +
                                                              "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////");
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Padding(
                                  child: Center(
                                    child: Text("No Current Week Activities"),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                        ),
                        StickyHeader(
                          header: Container(
                            child: Text(
                              "Upcoming",
                              style: textTheme.display1
                                  .copyWith(fontSize: 23, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                            color: Colors.blueAccent,
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                          ),
                          content: afterWeek.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  itemCount: afterWeekDates.keys.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int ac =
                                        afterWeekDates.keys.elementAt(index);
                                    List<Activites> accs = afterWeekDates[ac];
                                    DateTime dt =
                                        DateTime.fromMillisecondsSinceEpoch(ac)
                                            .toLocal();
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              color: Colors.grey,
                                              width: 1.2,
                                              height: 50,
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              child: Text(
                                                "${formatDate(dt, [
                                                  DD,
                                                  '\n',
                                                  mm,
                                                  '/',
                                                  dd,
                                                  '/',
                                                  yy,
                                                ])}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1.2,
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(2),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: accs.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Activites ac = accs[index];
                                              return buildActivityListItem(
                                                ac,
                                                context,
                                                onTap: () {
                                                  widget.appListener.router
                                                      .navigateTo(
                                                          context,
                                                          Screens.ADDACTIVITY
                                                                  .toString() +
                                                              "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////");
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Padding(
                                  child: Center(
                                    child: Text("No Upcoming Activities"),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                        ),
                        StickyHeader(
                          header: InkWell(
                            onTap: () {
                              setState(() {
                                isRecurring = !isRecurring;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Recurring",
                                style: textTheme.display1.copyWith(
                                    fontSize: 23,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              color: Colors.blueAccent,
                            ),
                          ),
                          content: isRecurring
                              ? recurring.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      itemCount: recurringDates.keys.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        int ac = recurringDates.keys
                                            .elementAt(index);
                                        List<Activites> accs =
                                            recurringDates[ac];
                                        DateTime dt =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    ac)
                                                .toLocal();
                                        return Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.grey,
                                                  width: 1.2,
                                                  height: 50,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  child: Text(
                                                    "${formatDate(dt, [
                                                      DD,
                                                      '\n',
                                                      mm,
                                                      '/',
                                                      dd,
                                                      '/',
                                                      yy,
                                                    ])}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.grey,
                                                  width: 1.2,
                                                  height: 50,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: accs.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Activites ac = accs[index];
                                                  return buildActivityListItem(
                                                    ac,
                                                    context,
                                                    onTap: () {
                                                      buildActivityListItem(
                                                          ac, context,
                                                          onTap: () {
                                                        widget
                                                            .appListener.router
                                                            .navigateTo(
                                                          context,
                                                          Screens.ADDACTIVITY
                                                                  .toString() +
                                                              "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////",
                                                        );
                                                      }, isPast: false);
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : Padding(
                                      child: Center(
                                        child: Text("No Recurring Activities"),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    )
                              : Container(
                                  padding: EdgeInsets.all(5),
                                ),
                        ),
                        StickyHeader(
                          header: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: double.infinity,
                              child: Text(
                                "Archive",
                                style: textTheme.display1.copyWith(
                                    fontSize: 23,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              color: Colors.blueAccent,
                            ),
                            onTap: () {
                              setState(() {
                                isArchive = !isArchive;
                              });
                            },
                          ),
                          content: isArchive
                              ? past.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      itemCount: pastDates.keys.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        int ac =
                                            pastDates.keys.elementAt(index);
                                        List<Activites> accs = pastDates[ac];
                                        DateTime dt =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    ac)
                                                .toLocal();
                                        return Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.grey,
                                                  width: 1.2,
                                                  height: 50,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.3,
                                                  child: Text(
                                                    "${formatDate(dt, [
                                                      DD,
                                                      '\n',
                                                      mm,
                                                      '/',
                                                      dd,
                                                      '/',
                                                      yy,
                                                    ])}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.grey,
                                                  width: 1.2,
                                                  height: 50,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: accs.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Activites ac = accs[index];
                                                  return buildActivityListItem(
                                                      ac, context, onTap: () {
                                                    widget.appListener.router
                                                        .navigateTo(
                                                      context,
                                                      Screens.ADDACTIVITY
                                                              .toString() +
                                                          "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////",
                                                    );
                                                  }, isPast: true);
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : Padding(
                                      child: Center(
                                        child: Text("No Past Activities"),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    )
                              : Container(),
                        ),
                      ],
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
      floatingActionButton: widget.bandId.isEmpty ||
              (widget.bandId != null && (widget.isLeader || widget.isComm))
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.green,
              overlayColor: Colors.white,
              overlayOpacity: 1.0,
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
                "Okay",
                textAlign: TextAlign.center,
              ),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(40, 35, 188, 1.0),
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

  @override
  void bandDetails(Band band) {
    setState(() {
      bandName = band.name;
    });
  }
}
