import 'package:flutter/cupertino.dart';
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
    return Container(
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
                      Icons.notifications,
                    ),
                    color: Colors.blue,
                    iconSize: 42,
                    onPressed: () {
                      widget.appListener.router.navigateTo(
                        context,
                        Screens.NOTIFICATION.toString(),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(3),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.power_settings_new,
                      color: Colors.green,
                    ),
                    color: Colors.white,
                    iconSize: 42,
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
            padding: EdgeInsets.all(1),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.42,
              children: [
                "Activities/Schedules",
                "Band",
                "Equipment",
                "Playing Style",
                "Contacts",
                "Admin",
                "Notes/Todo",
                "Bulletin Board"
              ].map(
                (txt) {
                  Color color = widget.appListener.primaryColor;
                  String image;
                  switch (txt) {
                    case "Activities/Schedules":
                      color=Color.fromRGBO(22,102,237, 1.0);
                      //color = Color.fromRGBO(235, 84, 99, 1.0);
                      image = 'assets/images/activities.png';
                      break;
                    case "Notes/Todo":
                      color=Color.fromRGBO(131,36, 77, 1.0);
                      //color = Color.fromRGBO(105, 114, 98, 1.0);
                      image = 'assets/images/activities.png';
                      break;
                    case "Band":
                      color=Color.fromRGBO(214,22, 35, 1.0);
                      //color = Color.fromRGBO(135, 67, 125, 1.0);
                      image = 'assets/images/band.png';
                      break;
                    case "Equipment":
                      color=Color.fromRGBO(60, 111, 55, 1.0);
                      //color = Color.fromRGBO(79, 73, 108, 1.0);
                      image = 'assets/images/equipment.png';
                      break;
                    case "Playing Style":
                      color=Color.fromRGBO(80, 54, 116, 1.0);
                      //color = Color.fromRGBO(82, 149, 171, 1.0);
                      image = 'assets/images/playingstyle.png';
                      break;
                    case "Contacts":
                      color= Color.fromRGBO(84, 34, 20, 1.0);
                      //color = Color.fromRGBO(82, 149, 171, 1.0);
                      image = 'assets/images/contacts.png';
                      break;
                    case "Admin":
                      color= Color.fromRGBO(114, 22, 25, 1.0);
                      //color = Color.fromRGBO(18, 130, 119, 1.0);
                      image = 'assets/images/admin.png';
                      break;
                    case "Bulletin Board":
                      color = Color.fromRGBO(0, 77, 71, 1.0);
                      image = 'assets/images/activities.png';
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
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    image,
                                    height: 40,
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
                                        fontSize: 19),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      if (txt == "Activities/Schedules")
                        widget.appListener.router.navigateTo(
                            context, Screens.ACTIVITIESLIST.toString());
                      else if (txt == "Notes/Todo")
                        widget.appListener.router.navigateTo(
                            context, Screens.NOTETODOLIST.toString());
                      else if (txt == "Band")
                        widget.appListener.router
                            .navigateTo(context, Screens.BANDLIST.toString());
                      else if (txt == "Equipment")
                        widget.appListener.router.navigateTo(
                            context, Screens.INSTRUMENTLIST.toString());
                      else if (txt == "Playing Style")
                        widget.appListener.router.navigateTo(
                            context, Screens.PLAYINGSTYLELIST.toString());
                      else if (txt == "Contacts")
                        widget.appListener.router.navigateTo(
                            context, Screens.CONTACTLIST.toString());
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
}
