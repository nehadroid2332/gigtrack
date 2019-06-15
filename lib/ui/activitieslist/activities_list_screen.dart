import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_presenter.dart';

class ActivitiesListScreen extends BaseScreen {
  ActivitiesListScreen(AppListener appListener)
      : super(appListener, title: "Activities/Schedules");

  @override
  _ActivitiesListScreenState createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState
    extends BaseScreenState<ActivitiesListScreen, ActivitiesListPresenter> {
  @override
  Widget buildBody() {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Title",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Location: ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "12/12/12 03:45 PM",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.appListener.router
              .navigateTo(context, Screens.ADDACTIVITY.toString());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  ActivitiesListPresenter get presenter => ActivitiesListPresenter(this);
}
