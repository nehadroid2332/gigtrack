import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/notifications.dart';
import 'package:gigtrack/server/models/user_instrument.dart';
import 'package:gigtrack/ui/notificationlist/notification_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class NotificationListScreens extends BaseScreen {
  NotificationListScreens(AppListener appListener)
      : super(appListener, title: "Notifications");

  @override
  _NotificationListScreensState createState() =>
      _NotificationListScreensState();
}

class _NotificationListScreensState
    extends BaseScreenState<NotificationListScreens, NotificationListPresenter>
    implements NotificationListContract {
  var _activities = <Activites>[];
  final _warranty = <UserInstrument>[];
  var _todos = <NotesTodo>[];
  var _notificationList = <AppNotification>[];
  bool isCalendar;

  // Stream<List<Activites>> activitiesList;
  // Stream<List<UserInstrument>> equipmentList;
  // Stream<List<NotesTodo>> notesList;
  Stream<List<AppNotification>> notificationList;

  @override
  void initState() {
    super.initState();
    // activitiesList = presenter.getAList();
    // equipmentList = presenter.getEList();
    // notesList = presenter.getNList();
    notificationList = presenter.getNotificationList();
  }

  @override
  AppBar get appBar => AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(105, 114, 98, 1.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${"Notification List"}",
          style: textTheme.title.copyWith(
            color: widget.appListener.primaryColor,
          ),
        ),
      );

  @override
  Widget buildBody() {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          StreamBuilder(
            stream: notificationList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _notificationList = snapshot.data;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _notificationList.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    AppNotification ac = _notificationList[index];
                    return Container(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: Column(
                        children: <Widget>[


                          InkWell(
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/notificationbell.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Flexible(
                                  child: Text("${ac.text}",
                                      softWrap: true,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left,
                                      maxLines: 2),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                            onTap: () {
                              switch (ac.type) {
                                case AppNotification.TYPE_ACTIVITY:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDACTIVITY.toString() +
                                          "/${ac.type}/${ac.notiId}/${false}/${ac.bandId}////");
                                  break;
                                case AppNotification.TYPE_BAND:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDBAND.toString() +
                                          "/${ac.notiId}");
                                  break;
                                case AppNotification.TYPE_BULLETIN_BOARD:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDBULLETIN.toString() +
                                          "/${ac.notiId}");
                                  break;
                                case AppNotification.TYPE_CONTACT:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDCONTACT.toString() +
                                          "/${ac.notiId}/${ac.bandId}////");
                                  break;
                                case AppNotification.TYPE_EPK:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDPLAYINGSTYLE.toString() +
                                          "/${ac.notiId}/////");
                                  break;
                                case AppNotification.TYPE_INSTRUMENT:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDINSTRUMENT.toString() +
                                          "/${ac.notiId}/${ac.bandId}////");
                                  break;
                                case AppNotification.TYPE_NOTES:
                                  widget.appListener.router.navigateTo(
                                      context,
                                      Screens.ADDNOTE.toString() +
                                          "/${ac.notiId}//${ac.bandId}/////${NotesTodo.TYPE_NOTE}/");
                                  break;
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          Row(
                            children: <Widget>[
                            Center(
                              child:  ac.bandId != null
                                  ? Text(
                                " ${ac.band?.name}",
                                style: textTheme.caption,
                                textAlign: TextAlign.center,
                              )
                                  : Container()
                            ),
                            Center(
                              child: (ac.sender != null && ac.sender.firstName.isNotEmpty)
                                  ? Text(
                                " - ${ac.sender?.firstName} ${ac.sender?.lastName} :",
                                style: textTheme.caption,
                                textAlign: TextAlign.right,
                              )
                                  : Container() ,
                            ),Center(child: Text(
                              " - ${formatDate(DateTime.fromMillisecondsSinceEpoch(ac.created), [
                                M,
                                ' ',
                                d,
                                ', ',
                                yyyy,
                                ' ',
                                hh,
                                ':',
                                mm,
                                ' ',
                                am
                              ])}",
                              textAlign: TextAlign.left,
                              style: textTheme.caption,
                            ),)
                          ],mainAxisAlignment: MainAxisAlignment.center,),
//                          Row(
//                            children: <Widget>[
//                              Padding(
//                                  padding: EdgeInsets.symmetric(
//                                horizontal: 10,
//                              )),
//                              Expanded(flex:(ac.sender != null && ac.sender.firstName.isNotEmpty)?1:0,
//                                child: Row(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//
//                                ],mainAxisAlignment: MainAxisAlignment.center,
//                              ),),
//                              Expanded(flex:1,
//                                child: Row(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//
//                                  ],mainAxisAlignment: MainAxisAlignment.center,
//                                ),),
//
//                              Expanded(
//                                flex:1,
//                                child: Container(
//                                  child: Text(
//                                    "${formatDate(DateTime.fromMillisecondsSinceEpoch(ac.created), [
//                                      M,
//                                      ' ',
//                                      d,
//                                      ', ',
//                                      yyyy,
//                                      ' ',
//                                      hh,
//                                      ':',
//                                      mm,
//                                      ' ',
//                                      am
//                                    ])}",
//                                    textAlign: TextAlign.left,
//                                    style: textTheme.caption,
//                                  ),
//                                  alignment: Alignment.centerRight,
//                                ),
//                              ),
//                            ],
//                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      width: MediaQuery.of(context).size.width,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error Occured"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: AppProgressWidget(),
                );
              }
              return Container();
            },
          ),

          // Container(
          //   child: Text(
          //     "Schedules/Activities",
          //     style: TextStyle(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 17,
          //         color: Colors.white),
          //     textAlign: TextAlign.center,
          //   ),
          //   padding: EdgeInsets.all(6),
          //   color: widget.appListener.primaryColorDark,
          // ),
          // StreamBuilder(
          //   stream: activitiesList,
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData) {
          //       _activities = snapshot.data;

          //       return ListView.builder(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         itemCount: _activities.length,
          //         padding: EdgeInsets.all(10),
          //         itemBuilder: (BuildContext context, int index) {
          //           Activites ac = _activities[index];
          //           return buildActivityListItem(ac, context, isCalendar,
          //               onTap: () {
          //             widget.appListener.router.navigateTo(
          //                 context,
          //                 Screens.ADDACTIVITY.toString() +
          //                     "/${ac.type}/${ac.id}/${false}/////");
          //           });
          //         },
          //       );
          //     } else if (snapshot.hasError) {
          //       return Center(
          //         child: Text("Error Occured"),
          //       );
          //     } else if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: AppProgressWidget(),
          //       );
          //     }
          //     return Container();
          //   },
          // ),
          // Container(
          //   child: Text(
          //     "Notes/Todo",
          //     style: TextStyle(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 17,
          //         color: Colors.white),
          //     textAlign: TextAlign.center,
          //   ),
          //   padding: EdgeInsets.all(6),
          //   color: widget.appListener.primaryColorDark,
          // ),
          // StreamBuilder(
          //     stream: notesList,
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData) {
          //         _todos = snapshot.data;
          //       }
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: _todos.length,
          //         physics: NeverScrollableScrollPhysics(),
          //         padding: EdgeInsets.all(10),
          //         itemBuilder: (BuildContext context, int index) {
          //           NotesTodo todo = _todos[index];
          //           return buildNoteListItem(
          //               todo, widget.appListener.primaryColor, onTap: () {
          //             widget.appListener.router.navigateTo(
          //                 context,
          //                 Screens.ADDNOTE.toString() +
          //                     "/${todo.id}///////${todo.type ?? NotesTodo.TYPE_NOTE}");
          //           });
          //         },
          //       );
          //     }),
          // // Container(
          //   child: Text(
          //     "Warranty",
          //     style: TextStyle(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 17,
          //         color: Colors.white),
          //     textAlign: TextAlign.center,
          //   ),
          //   padding: EdgeInsets.all(6),
          //   color: widget.appListener.primaryColorDark,
          // ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: _warranty.length,
          //   padding: EdgeInsets.all(10),
          //   itemBuilder: (BuildContext context, int index) {
          //     Instrument instrument = _warranty[index];
          //     return Container();
          //   },
          // ),
        ],
      ),
    );
  }

  @override
  NotificationListPresenter get presenter => NotificationListPresenter(this);
}
