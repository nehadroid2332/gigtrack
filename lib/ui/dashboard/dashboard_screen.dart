import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/dashboard/dashboard_presenter.dart';

class DashboardScreen extends BaseScreen {
  DashboardScreen(AppListener appListener) : super(appListener);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState
    extends BaseScreenState<DashboardScreen, DashboardPresenter> {
  @override
  Widget buildBody() {
    return Container(
      color: widget.appListener.primaryColor,
      child: Center(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children:
              ["Activities/Schedules", "Notes/ToDo", "Band", "Instrument"].map(
            (txt) {
              return GridTile(
                child: InkWell(
                  child: Card(
                    child: Center(
                      child: Text(
                        "$txt",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (txt == "Activities/Schedules")
                      widget.appListener.router.navigateTo(
                          context, Screens.ACTIVITIESLIST.toString());
                    else if (txt == "Notes/ToDo")
                      widget.appListener.router
                          .navigateTo(context, Screens.NOTETODOLIST.toString());
                  },
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  @override
  DashboardPresenter get presenter => DashboardPresenter(this);
}
