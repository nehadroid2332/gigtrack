import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gigtrack/ui/activitieslist/activities_list_screen.dart';
import 'package:gigtrack/ui/addactivity/add_activity_screen.dart';
import 'package:gigtrack/ui/addband/add_band_screen.dart';
import 'package:gigtrack/ui/addbandcomm/addband_comm_screen.dart';
import 'package:gigtrack/ui/addbulletinboard/addbulletinboard_screen.dart';
import 'package:gigtrack/ui/addcontact/add_contact_screen.dart';
import 'package:gigtrack/ui/addfeedback/add_feedback_screen.dart';
import 'package:gigtrack/ui/addinstrument/add_instrument_screen.dart';
import 'package:gigtrack/ui/addmembertoband/addmembertobandscreen.dart';
import 'package:gigtrack/ui/addnotes/add_notes_screen.dart';
import 'package:gigtrack/ui/addpayment/addpayment_screen.dart';
import 'package:gigtrack/ui/addsetlist/addsetlist_screen.dart';
import 'package:gigtrack/ui/addsong/add_song_screen.dart';
import 'package:gigtrack/ui/addtravel/addtravel_screen.dart';
import 'package:gigtrack/ui/bandcommlist/band_comm_list_screen.dart';
import 'package:gigtrack/ui/bandlist/bandlist_screen.dart';
import 'package:gigtrack/ui/bulletinboardlist/bulletinboard_list_screen.dart';
import 'package:gigtrack/ui/contactlist/contact_list_screen.dart';
import 'package:gigtrack/ui/dashboard/dashboard_screen.dart';
import 'package:gigtrack/ui/feedbacklist/feedbacklist_screen.dart';
import 'package:gigtrack/ui/forgotpassword/forgot_password_screen.dart';
import 'package:gigtrack/ui/google_maps_screen/google_maps_screen.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_screen.dart';
import 'package:gigtrack/ui/login/login_screen.dart';
import 'package:gigtrack/ui/noteslist/notes_list_screen.dart';
import 'package:gigtrack/ui/notificationlist/notification_list_screen.dart';
import 'package:gigtrack/ui/paymentlist/paymentlist_screen.dart';
import 'package:gigtrack/ui/profile/profile_screen.dart';
import 'package:gigtrack/ui/setlist/setlist_screen.dart';
import 'package:gigtrack/ui/signup/signup_screen.dart';
import 'package:gigtrack/ui/splash/splash_screen.dart';
import 'package:gigtrack/utils/privacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'server/models/notestodo.dart';
import 'ui/addplayingstyle/add_playing_style_screen.dart';
import 'ui/help/help_screen.dart';
import 'ui/playingstylelist/playing_style_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget implements AppListener {
  final _router = Router();
  SharedPreferences _prefs;
//  static FirebaseAnalytics analytics = FirebaseAnalytics();
//  static FirebaseAnalyticsObserver observer =
//      FirebaseAnalyticsObserver(analytics: analytics);

  MyApp() {
    _router.define("/", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SplashScreen(this);
    }));
    _router.define(Screens.LOGIN.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginScreen(
        this,
//        analytics: analytics,
//        observer: observer,
      );
    }));
    _router.define(Screens.SIGNUP.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return SignUpScreen(this);
    }));
    _router.define(Screens.HELP.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return HelpScreen(this);
    }));
    _router.define(Screens.ADDBAND.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddBandScreen(
        this,
        id: id,
      );
    }));
    _router.define(
        Screens.ADDINSTRUMENT.toString() +
            "/:id/:bandId/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String bandId = params["bandId"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";

      return AddInstrumentScreen(
        this,
        id: id,
        bandId: bandId,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
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
    _router.define(
        Screens.ACTIVITIESLIST.toString() +
            "/:bandid/:isLeader/:isComm/:isSetUp/:postEntries/:type",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["bandid"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";
      int type;
      if (params['type'][0] != null && "${params['type'][0]}".isNotEmpty)
        type = int.parse(params['type'][0]);
      return ActivitiesListScreen(
        this,
        bandId: id,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
        type: type,
      );
    }));
    _router.define(
        Screens.NOTETODOLIST.toString() +
            "/:bandid/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["bandid"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";
      return NotesListScreen(
        this,
        bandId: id,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(Screens.BULLETINLISTLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return BulletInBoardListScreen(this);
    }));
    _router.define(Screens.PRIVACY.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return PrivacyScreen(this);
    }));
    _router.define(
        Screens.ADDACTIVITY.toString() +
            "/:type/:id/:isParent/:bandId/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      int type = int.parse(params["type"][0]);
      bool isParent = params["isParent"][0] == '${true}';
      String bandId = params['bandId'][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";
      return AddActivityScreen(
        this,
        id: id,
        type: type,
        bandId: bandId,
        isParent: isParent,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(
        Screens.ADDTRAVEL.toString() +
            "/:type/:id/:isParent/:bandId/:isLeader/:isComm/:isSetUp/:postEntries/:actiivtyId",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String actiivtyId = params["actiivtyId"][0];
      // int type = int.parse(params["type"][0]);
      // bool isParent = params["isParent"][0] == '${true}';
      // String bandId = params['bandId'][0];
      // bool isLeader = params['isLeader'][0] == "${true}";
      // bool isComm = params['isComm'][0] == "${true}";
      // bool isSetUp = params['isSetUp'][0] == "${true}";
      // bool postEntries = params['postEntries'][0] == "${true}";
      return AddTravelScreen(
        this,
        id: id,
        activityId: actiivtyId,
      );
    }));

    _router.define(
        Screens.ADDNOTE.toString() +
            "/:id/:isParent/:bandId/:isLeader/:isComm/:isSetUp/:postEntries/:type",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String bandId = params["bandId"][0];
      bool isParent = params["isParent"][0] == '${true}';
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";
      int type = int.parse(params['type'][0] ?? "${NotesTodo.TYPE_NOTE}");
      return AddNotesScreen(
        this,
        id: id,
        bandId: bandId,
        isParent: isParent,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        type: type,
        postEntries: postEntries,
      );
    }));
    _router.define(Screens.PROFILE.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ProfileScreen(
        this,
      );
    }));
    _router.define(Screens.ADDBULLETIN.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddBulletInBoardScreen(
        this,
        id: id,
      );
    }));
    _router.define(Screens.ADDSETLIST.toString() + "/:userId/:id", handler:
        Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String userId = params["userId"][0];
      String id = params["id"][0];
      return AddSetListScreen(
        this,
        bandId: userId,
        id: id,
      );
    }));
    _router.define(Screens.FEEDBACK.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return AddFeedbackScreen(
        this,
      );
    }));
    _router.define(
        Screens.ADD_BAND_COMM.toString() +
            "/:id/:isParent/:bandId/:isLeader/:isComm/:isSetUp/:postEntries/:type",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String bandId = params["bandId"][0];
      bool isParent = params["isParent"][0] == '${true}';
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";
      return AddBandCommScreen(
        this,
        id: id,
        bandId: bandId,
        isParent: isParent,
        isLeader: isLeader,
        isComm: isComm,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(
        Screens.BANDCOMMLIST.toString() +
            "/:bandid/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["bandid"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";
      return BandCommListScreen(
        this,
        bandId: id,
        isLeader: isLeader,
        isComm: isComm,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(Screens.SETLIST.toString() + "/:bandId", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String bandId = params["bandId"][0];
      return SetListScreen(
        this,
        bandId: bandId,
      );
    }));
    _router.define(Screens.BANDLIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return BandListScreen(this);
    }));
    _router.define(
        Screens.CONTACTLIST.toString() +
            "/:bandid/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["bandid"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";

      return ContactListScreen(
        this,
        bandId: id,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(
        Screens.INSTRUMENTLIST.toString() +
            "/:bandid/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["bandid"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";

      return InstrumentListScreen(
        this,
        bandId: id,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(Screens.NOTIFICATION.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return NotificationListScreens(this);
    }));
    _router.define(
        Screens.PLAYINGSTYLELIST.toString() +
            "/:bandid/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["bandid"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";

      return PlayingStyleListScreen(
        this,
        bandId: id,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(
        Screens.ADDPLAYINGSTYLE.toString() +
            "/:id/:bandId/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String bandId = params["bandId"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";

      return AddPlayingStyleScreen(
        this,
        bandId: bandId,
        id: id == "null" ? "" : id,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(Screens.FORGOTPASSWORD.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ForgotPasswordScreen(this);
    }));
    _router.define(
        Screens.ADDCONTACT.toString() +
            "/:id/:bandId/:isLeader/:isComm/:isSetUp/:postEntries",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String bandId = params["bandId"][0];
      bool isLeader = params['isLeader'][0] == "${true}";
      bool isComm = params['isComm'][0] == "${true}";
      bool isSetUp = params['isSetUp'][0] == "${true}";
      bool postEntries = params['postEntries'][0] == "${true}";

      return AddContactScreen(
        this,
        id: id,
        bandId: bandId,
        isComm: isComm,
        isLeader: isLeader,
        isSetUp: isSetUp,
        postEntries: postEntries,
      );
    }));
    _router.define(Screens.ADDMEMBERTOBAND.toString() + "/:id/:bandId", handler:
        Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      String bandId = params["bandId"][0];
      return AddMemberToBandScreen(
        this,
        id: id,
        bandId: bandId,
      );
    }));
    _router.define(Screens.FEEDBACK_LIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return FeedbackListScreen(this);
    }));
    _router.define(Screens.PAYMENT_LIST.toString(), handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return PaymentListScreen(this);
    }));
    _router.define(Screens.ADD_PAYMENT.toString() + "/:id", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String id = params["id"][0];
      return AddPaymentScreen(
        this,
        id: id,
      );
    }));
    _router.define(Screens.GOOGLEMAPS.toString() + "/:latitude/:longitude",
        handler: Handler(
            handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      double latitude = double.tryParse(params["latitude"][0]);
      double longitude = double.tryParse(params["longitude"][0]);
      return GoogleMapsScreen(
        this,
        latitude: latitude,
        longitude: longitude,
      );
    }));
    // _router.define(Screens.COURSEDETAILS.toString() + "/:id/:id2", handler:
    //     Handler(
    //         handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    //   return CourseDetailsScreen(this, params["id"][0], params["id2"][0]);
    // }));
    initPrefs();
//    PluginGooglePlacePicker.initialize(
//      androidApiKey: "AIzaSyB3Ux1Qpg9Ul1aA36g-fnQelUUT06qWJFI",
//      iosApiKey: "AIzaSyB3Ux1Qpg9Ul1aA36g-fnQelUUT06qWJFI",
//    );
  }
  //AIzaSyCiapnChsL10zjA5956IlTgccaQE8mM5G0
  //AIzaSyDPmfMCWQcPRNZOcsGXszKGJMs11FbUxtc

  void initPrefs() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(99, 97, 93, .8));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.blue, // Color for Android
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor:
            Colors.black87 // Dark == white status bar -- for IOS.
        ));
    return MaterialApp(
      title: 'GigTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        accentColor: accentColor,
        fontFamily: 'Mohave',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
        // additional settings go here
        fontFamily: 'Mohave',
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        accentColor: accentColor,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: .5),
          ),
          border: new UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.white, width: .5)),
        ),
      ),
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
  PRIVACY,
  ADDBULLETIN,
  BULLETINLISTLIST,
  GOOGLEMAPS,
  HELP,
  PROFILE,
  SETLIST,
  ADDSETLIST,
  FEEDBACK,
  ADDTRAVEL,
  FEEDBACK_LIST,
  PAYMENT_LIST,
  ADD_PAYMENT,
  ADD_BAND_COMM,
  BANDCOMMLIST
}
