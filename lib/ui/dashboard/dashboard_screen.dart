import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/ui/dashboard/dashboard_presenter.dart';

class DashboardScreen extends BaseScreen {
  DashboardScreen(AppListener appListener) : super(appListener);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState
    extends BaseScreenState<DashboardScreen, DashboardPresenter>
    implements DashboardContract {
  String userPlayingStyleId;

  @override
  void initState() {
    super.initState();
    presenter.doWelcome();
    presenter.getPlayingStyleList("");
  }

  
  @override
  Widget buildBody() {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//      systemNavigationBarColor: Colors.blue  ,
//  //    statusBarColor: Colors.blue, // Color for Android
////        statusBarBrightness: Brightness.light,
//        // Dark == white status bar -- for IOS.
//    ));
  
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    
      statusBarColor: Color.fromRGBO(99, 97, 93, .5),
  
    ));
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/rendered.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
      ),
      child:SafeArea(
        top: false,
        child:Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.only(
                  bottom: 0,
                ),
                child: Container(
//                decoration: new BoxDecoration(
//                  gradient: new LinearGradient(
//                      colors: [
//                       Color.fromRGBO(107, 105, 102, .9),
//                       Color.fromRGBO(79, 78, 76, .8)
//                      ],
//                      begin: const FractionalOffset(0.0, 0.0),
//                      end: const FractionalOffset(0.0, 1.0),
//                      stops: [0.0, 1.0],
//                      tileMode: TileMode.clamp),
//                ),
                  child:Row(
                    children: <Widget>[
//                  Expanded(
//                    child: Container(),
//                  ),
                      IconButton(
                        icon: Icon(
                          Icons.account_circle,
                        ),
                        color: Color.fromRGBO(222, 153, 24, 1.0),
                        iconSize: 26,
                        onPressed: () {
                          widget.appListener.router.navigateTo(
                            context,
                            Screens.PROFILE.toString(),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                        ),
                        color: Color.fromRGBO(222, 153, 24, 1.0),
                        iconSize: 26,
                        onPressed: () {
                          widget.appListener.router.navigateTo(
                            context,
                            Screens.NOTIFICATION.toString(),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.help,
                        ),
                        color: Color.fromRGBO(222, 153, 24, 1.0),
                        iconSize: 26,
                        onPressed: () {
                          widget.appListener.router.navigateTo(
                            context,
                            Screens.HELP.toString(),
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 20),),
                      IconButton(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                        iconSize: 36,
                        onPressed: () {
                          widget.appListener.sharedPreferences.clear();
                          presenter.logout();
                          widget.appListener.router.navigateTo(
                              context, Screens.LOGIN.toString(),
                              replace: true);
                        },
                      )
                    ],
                  ) ,)
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/Gigtrackupdate.png',
                          height: 70,
                        ),
                      ),
                    )
                  ],
                ),
              ),
//              Image.asset(
//                'assets/images/music.png',
//                height: 50,
//              )
            ],
          ),
          Padding(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.width / 19),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.36,
              children: [
                "ACTIVITIES",
                "BANDS",
                "CONTACTS",
                "EPK",
                "EQUIPMENT",
                "NOTES",
                "FEEDBACK",
                "BULLETIN BOARD"
              ].map(
                    (txt) {
                  Color color = widget.appListener.primaryColor;
                  Color borderColor = Colors.blue;
                  String image;
                  switch (txt) {
                    case "ACTIVITIES":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color = Color.fromRGBO(63, 146, 219, 1.0); last one
                      //	color = Color.fromRGBO(71, 151, 221, 0.1);
                      image = 'assets/images/finalcalander.svg';
                      borderColor = Color.fromRGBO(55, 0, 179, 1.0);
                      break;
                    case "NOTES":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color=Color.fromRGBO(239,181, 77, 1.0);
                      //	color = Color.fromRGBO(196, 227, 102, 0.1);
                      image = 'assets/images/notesicon.svg';
                      borderColor = Color.fromRGBO(3, 54, 255, 1.0);
                      break;
                    case "BANDS":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color=Color.fromRGBO(214,22, 35, 1.0);
                      //	color = Color.fromRGBO(241, 206, 96, 0.1);
                      image = 'assets/images/bandicon.svg';
                      borderColor = Color.fromRGBO(167, 0, 0, 1.0);
                      break;
                    case "EQUIPMENT":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color = Color.fromRGBO(210, 34, 153, 0.1);
                      //color = Color.fromRGBO(60, 111, 54, 1.0);
                      image = 'assets/images/radioicon.svg';
                      borderColor = Colors.deepOrangeAccent;
                      break;
                    case "EPK":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color=Color.fromRGBO(80, 54, 116, 1.0);
                      //	color = Color.fromRGBO(26, 182, 37, 0.1);
                      image = 'assets/images/microphoneepk.svg';
                      borderColor = Color.fromRGBO(250, 177, 49, 1.0);
                      break;
                    case "CONTACTS":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color= Color.fromRGBO(191, 53, 42, 1.0);
                      //color = Color.fromRGBO(243, 135, 75, 0.1);
                      image = 'assets/images/telcontact.svg';
                      borderColor = Color.fromRGBO(3, 218, 157, 1.0);//Color.fromRGBO(3, 54, 255, 1.0);
                      break;
                    case "FEEDBACK":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color = Color.fromRGBO(102, 187, 238, 0.1);
                      //color = Color.fromRGBO(18, 130, 119, 1.0);
                      image = 'assets/images/feedbackicon.svg';
                      borderColor = Colors.grey;
                      break;
                    case "BULLETIN BOARD":
                    //	color = Color.fromRGBO(251, 111, 162, 0.1);
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      image = 'assets/images/finalbulletin.svg';
                      borderColor = Colors.black;
                      break;
                  }
                  return InkWell(
                    child: Container(
                        child: Card(
                            margin: EdgeInsets.all(5),
                            color: color,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: new BorderSide(
                                  color: borderColor, width: 2.5),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/newupdated.png"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 6, bottom: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                            
                                  ///mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(padding: EdgeInsets.only(
                                                  left: 0, right: 0, top: 6, bottom: 6)),
                                              new SvgPicture.asset(
                                                image,
                                                height: MediaQuery.of(context).size.height/13,
                                                allowDrawingOutsideViewBox: true,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 1,
                                                    bottom: 1),
                                              ),
                                              AutoSizeText(
                                                "$txt",
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: textTheme.headline.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ))),
                    onTap: () async {
                      if (txt == "ACTIVITIES")
                        widget.appListener.router.navigateTo(context,
                            Screens.ACTIVITIESLIST.toString() + "//////");
                      else if (txt == "NOTES")
                        widget.appListener.router.navigateTo(
                            context, Screens.NOTETODOLIST.toString() + "/////");
                      else if (txt == "BANDS")
                        widget.appListener.router
                            .navigateTo(context, Screens.BANDLIST.toString());
                      else if (txt == "EQUIPMENT")
                        widget.appListener.router.navigateTo(context,
                            Screens.INSTRUMENTLIST.toString() + "/////");
                      else if (txt == "EPK") {
                        if (userPlayingStyleId == null) {
                          await widget.appListener.router.navigateTo(context,
                              Screens.ADDPLAYINGSTYLE.toString() + "//////");
                        } else {
                          await widget.appListener.router.navigateTo(
                              context,
                              Screens.ADDPLAYINGSTYLE.toString() +
                                  "/$userPlayingStyleId/////");
                        }
                        userPlayingStyleId = "";
                        presenter.getPlayingStyleList("");
                      } else if (txt == "CONTACTS")
                        widget.appListener.router.navigateTo(
                            context, Screens.CONTACTLIST.toString() + "/////");
                      else if (txt == "BULLETIN BOARD")
                        widget.appListener.router.navigateTo(
                            context, Screens.BULLETINLISTLIST.toString());
                      else if (txt == "FEEDBACK")
                        widget.appListener.router
                            .navigateTo(context, Screens.PAYMENT_LIST.toString());
                    },
                  );
                },
              ).toList(),
            ),
          )
        ],
      ) ,)
    );
  }

  @override
  DashboardPresenter get presenter => DashboardPresenter(this);

  @override
  void onData(List<UserPlayingStyle> acc) {
    if (acc.length > 0) {
      UserPlayingStyle userPlayingStyle = acc[0];
      userPlayingStyleId = userPlayingStyle.id;
    }
  }

  @override
  void showWelcome(String userId) {
    bool welcome = widget.appListener.sharedPreferences.getBool(userId);
    if (welcome == null || !welcome)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            contentPadding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: new Text(
              "Welcome",
              textAlign: TextAlign.center,
            ),
            content: Text(
                "\nThanks for joining up with us during our tour rehearsal. Your experience here is very important to us.\n\nPlease use every feature and let us know what you think. We want to hear your feedback on colors,displays,functionality,issues and anything that can make our app better for you.\n\nSincerely,\nThe Gigtrack Team"),
            actions: <Widget>[
              new RaisedButton(
                child: new Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                color: Color.fromRGBO(22, 102, 237, 1.0),
                onPressed: () async {
                  await widget.appListener.sharedPreferences
                      .setBool(userId, true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }
}
