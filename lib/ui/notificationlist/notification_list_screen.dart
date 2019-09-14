import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/notification_list_response.dart';
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

  Stream<List<Activites>> activitiesList;
  Stream<List<UserInstrument>> equipmentList;
  Stream<List<NotesTodo>> notesList;

  @override
  void initState() {
    super.initState();
    activitiesList = presenter.getAList();
    equipmentList = presenter.getEList();
    notesList = presenter.getNList();
  }

  @override
  Widget buildBody() {
    return Container(
      child: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          Container(
            child: Text(
              "Schedules/Activities",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(6),
            color: widget.appListener.primaryColorDark,
          ),
          StreamBuilder(
            stream: activitiesList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _activities = snapshot.data;
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _activities.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  Activites ac = _activities[index];
                  return buildActivityListItem(ac, onTap: () {
                    widget.appListener.router.navigateTo(
                        context, Screens.ADDACTIVITY.toString() + "/${ac.id}");
                  });
                },
              );
            },
          ),
          Container(
            child: Text(
              "Notes/Todo",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(6),
            color: widget.appListener.primaryColorDark,
          ),
          StreamBuilder(
              stream: notesList,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _todos = snapshot.data;
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _todos.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (BuildContext context, int index) {
                    NotesTodo todo = _todos[index];
                    return buildNoteListItem(
                        todo, widget.appListener.primaryColor, onTap: () {
                      widget.appListener.router.navigateTo(
                          context, Screens.ADDNOTE.toString() + "/${todo.id}");
                    });
                  },
                );
              }),
          // Container(
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
