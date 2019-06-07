import 'package:flutter/material.dart';
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
    return Container();
  }

  @override
  DashboardPresenter get presenter => DashboardPresenter(this);
}
