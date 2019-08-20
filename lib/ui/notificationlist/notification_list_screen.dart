import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/notification_list_response.dart';
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
  final _activities = <Activites>[];
  final _warranty = <Instrument>[];
  final _todos = <NotesTodo>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getNotifications();
    });
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
          ListView.builder(
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: _todos.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (BuildContext context, int index) {
              NotesTodo todo = _todos[index];
              return buildNoteListItem(todo, widget.appListener.primaryColor,
                  onTap: () {
                widget.appListener.router.navigateTo(
                    context, Screens.ADDNOTE.toString() + "/${todo.id}");
              });
            },
          ),
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

  @override
  void onNotificationSuccess(NotificationListResponse res) {
    hideLoading();
    setState(() {
      _activities.addAll(res.activities);
      _activities.addAll(res.schedules);
      _warranty.addAll(res.instruments);
      _todos.addAll(res.todos);
    });
  }
}
