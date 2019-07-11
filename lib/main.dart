import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_screen.dart';
import 'package:gigtrack/ui/addactivity/add_activity_screen.dart';
import 'package:gigtrack/ui/addband/add_band_screen.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_screen.dart';
import 'package:gigtrack/ui/addnotes/add_notes_screen.dart';
import 'package:gigtrack/ui/addsong/add_song_screen.dart';
import 'package:gigtrack/ui/bandlist/bandlist_screen.dart';
import 'package:gigtrack/ui/dashboard/dashboard_screen.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_screen.dart';
import 'package:gigtrack/ui/login/login_screen.dart';
import 'package:gigtrack/ui/noteslist/notes_list_screen.dart';
import 'package:gigtrack/ui/notificationlist/notification_list_screen.dart';
import 'package:gigtrack/ui/signup/signup_screen.dart';
import 'package:gigtrack/ui/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget implements AppListener {
  final _router = Router();
  SharedPreferences _prefs;

  MyApp() {
    _router.define("/", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SplashScreen(this);
    }));
    _router.define(Screens.LOGIN.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginScreen(this);
    }));
    _router.define(Screens.SIGNUP.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SignUpScreen(this);
    }));
    _router.define(Screens.ADDBAND.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddBandScreen(
        this,
        id: id,
      );
    }));
    _router.define(Screens.ADDINSTRUMENT.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddInstrumentScreen(

        this,
        id: id,
      );
    }));
    _router.define(Screens.ADDSONG.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return AddSongScreen(this);
    }));
    _router.define(Screens.DASHBOARD.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return DashboardScreen(this);
    }));
    _router.define(Screens.ACTIVITIESLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ActivitiesListScreen(this);
    }));
    _router.define(Screens.NOTETODOLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return NotesListScreen(this);
    }));
    _router.define(Screens.ADDACTIVITY.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddActivityScreen(
        this,
        id: id,
      );
    }));
    _router.define(Screens.ADDNOTE.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddNotesScreen(
        this,
        id: id,
      );
    }));
    _router.define(Screens.BANDLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return BandListScreen(this);
    }));
    _router.define(Screens.INSTRUMENTLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return InstrumentListScreen(this);
    }));
    _router.define(Screens.NOTIFICATION.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return NotificationListScreens(this);
    }));

    // _router.define(Screens.COURSEDETAILS.toString() + "/:id/:id2", handler:
    //     Handler(
    //         handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    //   return CourseDetailsScreen(this, params["id"][0], params["id2"][0]);
    // }));
    initPrefs();
  }

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GigTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        accentColor: accentColor,
      ),
      onGenerateRoute: _router.generator,
    );
  }

  @override
  Color get primaryColor => Color.fromRGBO(18, 130, 119, 1.0);

  @override
  Router get router => _router;

  @override
  SharedPreferences get sharedPreferences => _prefs;

  @override
  Color get primaryColorDark => Color.fromRGBO(0, 77, 71, 1.0);

  @override
  Color get accentColor => Color.fromRGBO(185, 196, 201, 1.0);
}

abstract class AppListener {
  Router get router;
  SharedPreferences get sharedPreferences;
  Color get primaryColor;
  Color get primaryColorDark;
  Color get accentColor;
}

enum Screens {
  LOGIN,
  SIGNUP,
  ADDBAND,
  ADDINSTRUMENT,
  ADDSONG,
  DASHBOARD,
  ACTIVITIESLIST,
  NOTETODOLIST,
  ADDACTIVITY,
  ADDNOTE,
  BANDLIST,
  INSTRUMENTLIST,
  NOTIFICATION,
}
