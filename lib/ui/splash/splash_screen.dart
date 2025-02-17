import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';

import 'splash_presenter.dart';

class SplashScreen extends BaseScreen {
  SplashScreen(appListener) : super(appListener);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseScreenState<SplashScreen, SplashPresenter>
    implements SplashContract {
  @override
  void initState() {
    super.initState();
    presenter.movetoLogin();
  }

  @override
  Widget buildBody() {
    return new Container(
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/rendered.png'),
          fit: BoxFit.cover,
        ),
        gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: [
            widget.appListener.primaryColor,
            widget.appListener.accentColor
          ], //tish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/Gigtrackupdate.png',
        ),
      ),
    );
  }

  @override
  SplashPresenter get presenter => SplashPresenter(this);

  @override
  void loginSuccess(bool isLoginSuccess) {
    if (isLoginSuccess) {
      widget.appListener.router.navigateTo(
        context,
        Screens.DASHBOARD.toString(),
        replace: true,
      );
    } else
      widget.appListener.router.navigateTo(
        context,
        Screens.LOGIN.toString(),
        replace: true,
      );
  }
}
