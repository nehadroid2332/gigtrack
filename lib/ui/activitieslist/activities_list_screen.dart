import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    presenter.getBands();
    list = presenter.getList(widget.bandId, widget.type);
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
          showDialogConfirm();
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
                        color: widget.appListener.primaryColorDark,
                        fontSize: 28),
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
                      // List<Activites> bandActivities = [];

                      DateTime currentDate = DateTime.now().toLocal();
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
                        int days = currentDate.difference(startDate).inDays;
                        int daysval= days* -1;
                        final difference =
                            currentDate.difference(startDate).inDays / 7 + 1;
                        final difference2 =
                            currentDate.difference(startDate).inDays;
                        final difference3 =
                            currentDate.difference(startDate).inDays / 7;
                       
                        int days2;
                        if (endDate != null) {
                          days2 = currentDate.difference(endDate).inDays;
                        }
                        // bool check = myBands.any((a) {
                        //   return a.id == ac.bandId;
                        // });
                        // if (check) {
                        //   bandActivities.add(ac);
                        // } else
                        if (ac.isRecurring) {
                          recurring.add(ac);
                        } else if ((daysval <= 7 && daysval >= 0)|| (days2 != null && (days2 <= 7&&days2 >0))) {
                          current.add(ac);
                         
                        } else if (daysval >7) {
                          upcoming.add(ac);
                          print("divide 7 "+difference3.toString());
                          print("no divide "+difference2.toString());
                          print("abc     :" + difference.toString());
                          print("activity name     :" + ac.title.toString());
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
                      current
                          .sort((a, b) => a.startDate.compareTo(b.startDate));
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

                      upcoming
                          .sort((a, b) => a.startDate.compareTo(b.startDate));
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

                      return ListView(
                        children: <Widget>[
                          Text(
                            "NEXT 7 days",
                            style: textTheme.display1.copyWith(
                                fontSize: 23,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          current.length > 0
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  itemCount: current.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Activites ac = current[index];
                                    return buildActivityListItem(ac, context,
                                        onTap: () {
                                      widget.appListener.router.navigateTo(
                                          context,
                                          Screens.ADDACTIVITY.toString() +
                                              "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////");
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
                            style: textTheme.display1.copyWith(fontSize: 23),
                            textAlign: TextAlign.center,
                          ),
                          upcoming.length > 0
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  itemCount: upcoming.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Activites ac = upcoming[index];
                                    return buildActivityListItem(ac, context,
                                        onTap: () {
                                      widget.appListener.router.navigateTo(
                                          context,
                                          Screens.ADDACTIVITY.toString() +
                                              "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////");
                                    });
                                  },
                                )
                              : Padding(
                                  child: Center(
                                    child: Text("No Upcoming Activities"),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),

                          InkWell(
                            onTap: () {
                              setState(() {
                                isRecurring = !isRecurring;
                              });
                            },
                            child: Text(
                              "Recurring",
                              style: textTheme.display1.copyWith(
                                  fontSize: 23,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          isRecurring
                              ? recurring.length > 0
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: recurring.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Activites ac = recurring[index];
                                        return buildActivityListItem(
                                            ac, context, onTap: () {
                                          widget.appListener.router.navigateTo(
                                            context,
                                            Screens.ADDACTIVITY.toString() +
                                                "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////",
                                          );
                                        }, isPast: false);
                                      },
                                    )
                                  : Padding(
                                      child: Center(
                                        child: Text("No Recurring Activities"),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    )
                              : Container(),
                          InkWell(
                            child: Text(
                              "Archive",
                              style: textTheme.display1.copyWith(
                                  fontSize: 23,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                              setState(() {
                                isArchive = !isArchive;
                              });
                            },
                          ),
                          isArchive
                              ? past.length > 0
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(10),
                                      itemCount: past.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Activites ac = past[index];
                                        return buildActivityListItem(
                                            ac, context, onTap: () {
                                          widget.appListener.router.navigateTo(
                                            context,
                                            Screens.ADDACTIVITY.toString() +
                                                "/${ac.type}/${ac.id}/${false}/${widget.bandId.isEmpty ? ac.bandId : widget.bandId}////",
                                          );
                                        },
                                            isPast: true);
//                                            (ac.type ==
//                                                    Activites.TYPE_TASK &&
//                                                (past[index].taskCompleteDate !=
//                                                            null
//                                                        ? ac.taskCompleteDate
//                                                        : 0) <
//                                                    currentDate
//                                                        .millisecondsSinceEpoch));
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
}
