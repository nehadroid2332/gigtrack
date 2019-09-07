import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class ActivitiesListScreen extends BaseScreen {
  ActivitiesListScreen(AppListener appListener)
      : super(appListener, title: "Activities/Schedules");

  @override
  _ActivitiesListScreenState createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState
    extends BaseScreenState<ActivitiesListScreen, ActivitiesListPresenter>
    implements ActivitiesListContract {
  List activities = <Activites>[];
  Stream<List<Activites>> list;

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
            color: widget.appListener.primaryColorDark,
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
                  "Activities/Schedule",
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
                    // Activites act = snapshot.data;
                    // if (!activities.contains(act)) {
                    //   activities.add(act);
                    // }
                    activities = snapshot.data;
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      Activites ac = activities[index];
                      return buildActivityListItem(ac, onTap: () {
                        widget.appListener.router.navigateTo(context,
                            Screens.ADDACTIVITY.toString() + "/${ac.id}");
                      });
                    },
                    itemCount: activities.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDACTIVITY.toString() + "/");
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: widget.appListener.primaryColorDark,
        ),
      ),
    );
  }

  @override
  ActivitiesListPresenter get presenter => ActivitiesListPresenter(this);
}
