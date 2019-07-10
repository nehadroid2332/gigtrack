import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseScreen extends StatefulWidget {
  final AppListener appListener;
  final String title;
  BaseScreen(this.appListener, {this.title});
}

abstract class BaseScreenState<B extends BaseScreen, P extends BasePresenter>
    extends State<B>
    implements BaseScreenComponents, BasePresenterComponents<P>, BaseContract {
  double width, height;
  TextTheme textTheme;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: isLoading ? loading : buildBody(),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment
                  .bottomRight, // 10% of the width, so there are ten blinds.
              colors: [
                widget.appListener.primaryColor,
                widget.appListener.accentColor,
                widget.appListener.primaryColorDark,
              ], //tish to gray
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
        ),
      ),
    );
  }

  @override
  Drawer get drawer => null;

  @override
  Color get backgroundColor => Colors.white;

  @override
  AppBar get appBar => widget.title != null
      ? AppBar(
          title: Text(widget.title),
        )
      : null;

  @override
  void showMessage(String message) {
    if (!mounted) return;

    hideLoading();
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  bool isLoading = false;

  @override
  void showLoading() {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return loading;
    //   },
    // );
  }

  @override
  void hideLoading() {
    // if (isLoading) Navigator.pop(context);
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget get loading => Center(
        // padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(26, 53, 52, 1.0)),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            new Text(
              "Loading",
              style: textTheme.body1.copyWith(
                color: widget.appListener.primaryColor,
              ),
            ),
          ],
        ),
      );
}

abstract class BaseScreenComponents {
  AppBar get appBar;
  Color get backgroundColor;
  Drawer get drawer;
  Widget buildBody();
  void showLoading();
  void hideLoading();
  Widget get loading;
}

abstract class BasePresenterComponents<P extends BasePresenter> {
  P get presenter;
}
