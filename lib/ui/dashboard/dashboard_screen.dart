import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
          image: AssetImage("assets/images/rendered.png"),
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
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 0,
              ),
              child: Row(
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
                          'assets/images/Gigtrackupdate.png',
                          height: 86,
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
                EdgeInsets.only(top: MediaQuery.of(context).size.width / 16),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.30,
              children: [
                "ACTIVITES",
                "BAND",
                "CONTACTS",
                "EPK",
                "EQUIPMENT",
                "NOTES",
                "BETA-TEST FEEDBACK",
                "BULLETIN BOARD"
              ].map(
                (txt) {
                  Color color = widget.appListener.primaryColor;
                  Color borderColor = Colors.blue;
                  String image;
                  switch (txt) {
                    case "ACTIVITES":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color = Color.fromRGBO(63, 146, 219, 1.0); last one
                      //	color = Color.fromRGBO(71, 151, 221, 0.1);
                      image = 'assets/images/feedbacknew.svg';
                      borderColor = Color.fromRGBO(55, 0, 179, 1.0);
                      break;
                    case "NOTES":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color=Color.fromRGBO(239,181, 77, 1.0);
                      //	color = Color.fromRGBO(196, 227, 102, 0.1);
                      image = 'assets/images/notesicon.svg';
                      borderColor = Color.fromRGBO(3, 218, 157, 1.0);
                      break;
                    case "BAND":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color=Color.fromRGBO(214,22, 35, 1.0);
                      //	color = Color.fromRGBO(241, 206, 96, 0.1);
                      image = 'assets/images/bandicon.svg';
                      borderColor = Color.fromRGBO(255, 2, 102, 1.0);
                      break;
                    case "EQUIPMENT":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color = Color.fromRGBO(210, 34, 153, 0.1);
                      //color = Color.fromRGBO(60, 111, 54, 1.0);
                      image = 'assets/images/instrumentimage.svg';
                      borderColor = Colors.deepOrangeAccent;
                      break;
                    case "EPK":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color=Color.fromRGBO(80, 54, 116, 1.0);
                      //	color = Color.fromRGBO(26, 182, 37, 0.1);
                      image = 'assets/images/epknew.svg';
                      borderColor = Color.fromRGBO(255, 222, 3, 1.0);
                      break;
                    case "CONTACTS":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color= Color.fromRGBO(191, 53, 42, 1.0);
                      //color = Color.fromRGBO(243, 135, 75, 0.1);
                      image = 'assets/images/telcontact.svg';
                      borderColor = Color.fromRGBO(3, 54, 255, 1.0);
                      break;
                    case "BETA-TEST FEEDBACK":
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      //color = Color.fromRGBO(102, 187, 238, 0.1);
                      //color = Color.fromRGBO(18, 130, 119, 1.0);
                      image = 'assets/images/feedbackicon.svg';
                      borderColor = Colors.grey;
                      break;
                    case "BULLETIN BOARD":
                      //	color = Color.fromRGBO(251, 111, 162, 0.1);
                      color = Color.fromRGBO(225, 222, 222, 0.7);
                      image = 'assets/images/bulletinnew.svg';
                      borderColor = Colors.black;
                      break;
                  }
                  return InkWell(
                    child: Container(child: Card(
                      margin: EdgeInsets.all(8),
                      color: color,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: new BorderSide(color: borderColor, width: 1.5),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/newupdated.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 8, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          ///mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                               
                                child: Center(
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
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),)
                    )),
                    onTap: () async {
                      if (txt == "ACTIVITES")
                        widget.appListener.router.navigateTo(context,
                            Screens.ACTIVITIESLIST.toString() + "//////");
                      else if (txt == "NOTES")
                        widget.appListener.router.navigateTo(
                            context, Screens.NOTETODOLIST.toString() + "/////");
                      else if (txt == "BAND")
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
                      else if (txt == "BETA-TEST FEEDBACK")
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
