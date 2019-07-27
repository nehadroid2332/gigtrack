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
  final activities = <Activites>[];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getList();
    });
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
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/activities_red.png',
              height: 60,
              width: 60,
            ),
            Text(
              "Activities/Schedule",
              style: textTheme.display1.copyWith(
                color: widget.appListener.primaryColorDark,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  Activites ac = activities[index];
                  return buildActivityListItem(ac, onTap: () {
                    widget.appListener.router.navigateTo(
                        context, Screens.ADDACTIVITY.toString() + "/${ac.id}");
                  });
                },
                itemCount: activities.length,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDACTIVITY.toString() + "/");
          showLoading();
          presenter.getList();
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

  @override
  void onActivitiesListSuccess(List<Activites> activities) {
    if (!mounted) return;
    hideLoading();
    setState(() {
      this.activities.clear();
      this.activities.addAll(activities);
    });
  }
}
