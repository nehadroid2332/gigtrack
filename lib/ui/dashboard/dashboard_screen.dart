import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    presenter.getPlayingStyleList("");
  }

  @override
  Widget buildBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 5,
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                    ),
                    color: Colors.blue,
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
                      Icons.help,
                    ),
                    color: Colors.blue,
                    iconSize: 26,
                    onPressed: () {
                      widget.appListener.router.navigateTo(
                        context,
                        Screens.HELP.toString(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                    ),
                    color: Colors.blue,
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
                      Icons.power_settings_new,
                      color: Colors.green,
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
              ),
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
                          'assets/images/logo.png',
                          height: 86,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Image.asset(
                'assets/images/music.png',
                height: 50,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.width/6),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.42,
              children: [
                "Activities",
                "Band",
                "Contacts",
                "EPK",
                "Equipment",
                "Notes",
                "Beta-Test Feedback",
                "Bulletin Board"
              ].map(
                (txt) {
                  Color color = widget.appListener.primaryColor;
                  String image;
                  switch (txt) {
                    case "Activities":
                      color = Color.fromRGBO(40, 35, 188, 1.0);
                      //color = Color.fromRGBO(235, 84, 99, 1.0);
                      image = 'assets/images/activitiesnew.svg';
                      break;
                    case "Notes":
                      //color=Color.fromRGBO(239,181, 77, 1.0);
                      color = Color.fromRGBO(196, 227, 102, 1.0);
                      image = 'assets/images/notesnew.svg';
                      break;
                    case "Band":
                      //color=Color.fromRGBO(214,22, 35, 1.0);
                      color = Color.fromRGBO(241, 206, 96, 1.0);
                      image = 'assets/images/bandnew.svg';
                      break;
                    case "Equipment":
                      color = Color.fromRGBO(210, 34, 153, 1.0);
                      //color = Color.fromRGBO(60, 111, 54, 1.0);
                      image = 'assets/images/equipmentnew.svg';
                      break;
                    case "EPK":
                      //color=Color.fromRGBO(80, 54, 116, 1.0);
                      color = Color.fromRGBO(26, 182, 37, 1.0);
                      image = 'assets/images/epknew.svg';
                      break;
                    case "Contacts":
                      //color= Color.fromRGBO(191, 53, 42, 1.0);
                      color = Color.fromRGBO(243, 135, 75, 1.0);
                      image = 'assets/images/contactsnew.svg';
                      break;
                    case "Beta-Test Feedback":
                      color = Color.fromRGBO(102, 187, 238, 1.0);
                      //color = Color.fromRGBO(18, 130, 119, 1.0);
                      image = 'assets/images/feedbacknew.svg';
                      break;
                    case "Bulletin Board":
                      color = Color.fromRGBO(251, 111, 162, 1.0);
                      image = 'assets/images/bulletinnew.svg';
                      break;
                  }
                  return InkWell(
                    child: Card(
                      margin: EdgeInsets.all(8),
                      color: color,
                      elevation: 13,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  new SvgPicture.asset(
                                    image,
                                    height: 66.0,
                                    
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 5, bottom: 5),
                                  ),
                                  Text(
                                    "$txt",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: textTheme.headline.copyWith(
                                        color:
                                            Color.fromRGBO(250, 250, 250, 1.0),
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (txt == "Activities")
                        widget.appListener.router.navigateTo(context,
                            Screens.ACTIVITIESLIST.toString() + "//////");
                      else if (txt == "Notes")
                        widget.appListener.router.navigateTo(
                            context, Screens.NOTETODOLIST.toString() + "/////");
                      else if (txt == "Band")
                        widget.appListener.router
                            .navigateTo(context, Screens.BANDLIST.toString());
                      else if (txt == "Equipment")
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
                      } else if (txt == "Contacts")
                        widget.appListener.router.navigateTo(
                            context, Screens.CONTACTLIST.toString() + "/////");
                      else if (txt == "Bulletin Board")
                        widget.appListener.router.navigateTo(
                            context, Screens.BULLETINLISTLIST.toString());
                      else if (txt == "Beta-Test Feedback")
                        widget.appListener.router
                            .navigateTo(context, Screens.FEEDBACK.toString());
                    },
                  );
                },
              ).toList(),
            ),
          )
        ],
      ),
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
}
