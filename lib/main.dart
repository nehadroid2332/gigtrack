import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_screen.dart';
import 'package:gigtrack/ui/addactivity/add_activity_screen.dart';
import 'package:gigtrack/ui/addband/add_band_screen.dart';
import 'package:gigtrack/ui/addcontact/add_contact_screen.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_screen.dart';
import 'package:gigtrack/ui/addmembertoband/addmembertobandscreen.dart';
import 'package:gigtrack/ui/addnotes/add_notes_screen.dart';
import 'package:gigtrack/ui/addsong/add_song_screen.dart';
import 'package:gigtrack/ui/bandlist/bandlist_screen.dart';
import 'package:gigtrack/ui/contactlist/contact_list_screen.dart';
import 'package:gigtrack/ui/dashboard/dashboard_screen.dart';
import 'package:gigtrack/ui/forgotpassword/forgot_password_screen.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_screen.dart';
import 'package:gigtrack/ui/login/login_screen.dart';
import 'package:gigtrack/ui/noteslist/notes_list_screen.dart';
import 'package:gigtrack/ui/notificationlist/notification_list_screen.dart';
import 'package:gigtrack/ui/signup/signup_screen.dart';
import 'package:gigtrack/ui/splash/splash_screen.dart';
import 'package:gigtrack/utils/privacy.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/addplayingstyle/add_playing_style_screen.dart';
import 'ui/playingstylelist/playing_style_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget implements AppListener {
  final _router = Router();
  SharedPreferences _prefs;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  MyApp() {
    _router.define("/", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SplashScreen(this);
    }));
    _router.define(Screens.LOGIN.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginScreen(
        this,
        analytics: analytics,
        observer: observer,
      );
    }));
    _router.define(Screens.SIGNUP.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SignUpScreen(this, analytics: analytics, observer: observer);
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
    _router.define(Screens.PRIVACY.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return PrivacyScreen(this);
    }));
    _router.define(Screens.ADDACTIVITY.toString() + "/:type/:id/:isParent",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      int type = int.parse(params["type"][0]);
      bool isParent = params["isParent"][0] == '${true}';
      return AddActivityScreen(
        this,
        id: id,
        type: type,
        isParent: isParent,
      );
    }));
    _router.define(Screens.ADDNOTE.toString() + "/:id/:isParent", handler:
        Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      bool isParent = params["isParent"][0] == '${true}';
      return AddNotesScreen(
        this,
        id: id,
        isParent: isParent,
      );
    }));
    _router.define(Screens.BANDLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return BandListScreen(this);
    }));
    _router.define(Screens.CONTACTLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ContactListScreen(this);
    }));
    _router.define(Screens.INSTRUMENTLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return InstrumentListScreen(this);
    }));
    _router.define(Screens.NOTIFICATION.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return NotificationListScreens(this);
    }));
    _router.define(Screens.PLAYINGSTYLELIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return PlayingStyleListScreen(this);
    }));
    _router.define(Screens.ADDPLAYINGSTYLE.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return AddPlayingStyleScreen(this);
    }));
    _router.define(Screens.FORGOTPASSWORD.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ForgotPasswordScreen(this);
    }));
    _router.define(Screens.ADDCONTACT.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddContactScreen(
        this,
        id: id,
      );
    }));
    _router.define(Screens.ADDMEMBERTOBAND.toString() + "/:id", handler:
        Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddMemberToBandScreen(this, id: id);
    }));
    // _router.define(Screens.COURSEDETAILS.toString() + "/:id/:id2", handler:
    //     Handler(
    //         handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    //   return CourseDetailsScreen(this, params["id"][0], params["id2"][0]);
    // }));
    initPrefs();
    PluginGooglePlacePicker.initialize(
      androidApiKey: "AIzaSyDPmfMCWQcPRNZOcsGXszKGJMs11FbUxtc",
      iosApiKey: "AIzaSyDPmfMCWQcPRNZOcsGXszKGJMs11FbUxtc",
    );
  }
  //AIzaSyCiapnChsL10zjA5956IlTgccaQE8mM5G0
  //AIzaSyDPmfMCWQcPRNZOcsGXszKGJMs11FbUxtc

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
          fontFamily: 'Mohave'),
      onGenerateRoute: _router.generator,
    );
  }

  @override
  Color get primaryColor => Color.fromRGBO(81, 3, 120, 1.0);

  @override
  Router get router => _router;

  @override
  SharedPreferences get sharedPreferences => _prefs;

  @override
  Color get primaryColorDark => Color.fromRGBO(45, 1, 79, 1.0);

  @override
  Color get accentColor => Color.fromRGBO(17, 5, 84, 1.0);
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
  PLAYINGSTYLELIST,
  ADDPLAYINGSTYLE,
  ADDMEMBERTOBAND,
  FORGOTPASSWORD,
  ADDCONTACT,
  CONTACTLIST,
  PRIVACY
}
