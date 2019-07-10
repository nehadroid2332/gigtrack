import 'package:date_format/date_format.dart';
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
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          Activites ac = activities[index];
          return buildActivityListItem(ac, onTap: () {
            widget.appListener.router.navigateTo(
                context, Screens.ADDACTIVITY.toString() + "/${ac.id}");
          });
        },
        itemCount: activities.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDACTIVITY.toString() + "/");
          showLoading();
          presenter.getList();
        },
        child: Icon(Icons.add),
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
