import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/utils/NumberTextInputFormatter.dart';

NumberTextInputFormatter phoneNumberFormatter = NumberTextInputFormatter(1);

class AppButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final onPressed;
  final double fontSize;

  const AppButton(
      {Key key,
      this.title,
      this.backgroundColor,
      this.textColor = Colors.black,
      this.radius = 0,
      this.fontSize = 14,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      child: RaisedButton(
        onPressed: onPressed,
        color: backgroundColor,
        child: Text(
          "$title",
          style: textTheme.button.copyWith(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      width: double.infinity,
      height: 42,
    );
  }
}

class IconTextButton extends StatelessWidget {
  final String image;
  final String text;
  final onPressed;
  final double height, width;

  const IconTextButton(
      {Key key,
      this.image,
      this.text,
      this.onPressed,
      this.height = 20,
      this.width = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(text),
            Image.asset(
              image,
              width: width,
              fit: BoxFit.contain,
              height: height,
            ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class TextCheckView extends StatelessWidget {
  final String title;
  final Color color;
  final bool check;

  final onTap;

  const TextCheckView(
      {this.title,
      this.color = Colors.lightGreenAccent,
      this.check = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(title),
            ),
            Icon(
              Icons.check_circle,
              color: check ? color : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black26});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

Widget dotView({Color color = Colors.greenAccent}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    margin: EdgeInsets.only(right: 15, left: 15),
    height: 8,
    width: 8,
  );
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return !regex.hasMatch(value);
}

bool validateMobile(String value) {
  return !(value.isNotEmpty && value.length == 10);
}

Widget buildActivityListItem(Activites ac,
    {bool showConfirm = false, onConfirmPressed, onTap, bool isPast = false}) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(ac.startDate).toLocal();
  return Card(
    color: isPast
        ? Colors.grey
        : (ac.bandId != null && ac.bandId.isNotEmpty)
            ? Colors.blueAccent
            : Color.fromRGBO(32, 95, 139, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                ),
                Text(
                  "${formatDate(dt, [D, '-', mm, '/', dd, '/', yy, ' -'])}",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(250, 250, 250, 0.8),
                  ),
                ),
                Text(
                  currentType(ac.type),
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(250, 250, 250, 1.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 13,
              right: 13,
              bottom: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${ac.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 23,
                    color: Color.fromRGBO(250, 250, 250, 1.0),
                  ),
                  textAlign: TextAlign.center,
                ),
                (ac.band?.name?.isNotEmpty ?? false)
                    ? Text(
                        ac.band?.name,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(250, 250, 250, 1.0),
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
      onTap: onTap,
    ),
  );
}

String currentType(int type) {
  if (type == 0) {
    return "Activity";
  } else if (type == 1) {
    return "Performance";
  } else if (type == 2) {
    return "Rehearsal";
  } else if (type == 3) {
    return "Task";
  }
  return "";
}

Widget buildNoteListItem(NotesTodo not, Color color, {onTap}) {
  DateTime stDate = DateTime.fromMillisecondsSinceEpoch((not.start_date));
  DateTime endDate = DateTime.fromMillisecondsSinceEpoch((not.end_date));

  return Card(
    margin: EdgeInsets.all(10),
    color: Color.fromRGBO(22, 102, 237, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${not.note}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            not.start_date == 0
                ? Container()
                : Text(
                    not.start_date == 0
                        ? ""
                        : "Remind me ${formatDate(stDate, [
                            DD,
                            '-',
                            mm,
                            '/',
                            dd,
                            '/',
                            yy,
                          ])}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

//            Padding(
//              padding: EdgeInsets.all(5),
//            ),
//            Row(
//              children: <Widget>[
//                Image.asset(
//                  'assets/images/calender.png',
//                  height: 20,
//                  width: 20,
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                Expanded(
//                  child: Text(
//                    "${formatDate(stDate, [
//                      yyyy,
//                      '-',
//                      mm,
//                      '-',
//                      dd
//                    ])}",
//                    style: TextStyle(fontSize: 12,color: Colors.white),
//                  ),
//                ),
//                Image.asset(
//                  'assets/images/calender.png',
//                  height: 20,
//                  width: 20,
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                Expanded(
//                  child: Text(
//                    "${formatDate(endDate, [
//                      yyyy,
//                      '-',
//                      mm,
//                      '-',
//                      dd
//                    ])}\n${formatDate(endDate, [HH, ':', nn, ':', ss])}",
//                    style: TextStyle(fontSize: 11,color: Colors.white),
//                  ),
//                )
            // ],
            // )
          ],
        ),
      ),
      onTap: onTap,
    ),
  );
}

Widget buildBulletInBoardListItem(BulletInBoard not, Color color, {onTap}) {
  DateTime stDate = DateTime.fromMillisecondsSinceEpoch((not.date));
  // DateTime endDate = DateTime.fromMillisecondsSinceEpoch((not.end_date));

  return Card(
    margin: EdgeInsets.all(10),
    color: Color.fromRGBO(214, 22, 35, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${not.item}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            not.date == 0
                ? Container()
                : Text(
                    not.date == 0
                        ? ""
                        : "${formatDate(stDate, [
                            DD,
                            '-',
                            mm,
                            '/',
                            dd,
                            '/',
                            yy,
                          ])}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

//            Padding(
//              padding: EdgeInsets.all(5),
//            ),
//            Row(
//              children: <Widget>[
//                Image.asset(
//                  'assets/images/calender.png',
//                  height: 20,
//                  width: 20,
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                Expanded(
//                  child: Text(
//                    "${formatDate(stDate, [
//                      yyyy,
//                      '-',
//                      mm,
//                      '-',
//                      dd
//                    ])}",
//                    style: TextStyle(fontSize: 12,color: Colors.white),
//                  ),
//                ),
//                Image.asset(
//                  'assets/images/calender.png',
//                  height: 20,
//                  width: 20,
//                ),
//                Padding(
//                  padding: EdgeInsets.all(5),
//                ),
//                Expanded(
//                  child: Text(
//                    "${formatDate(endDate, [
//                      yyyy,
//                      '-',
//                      mm,
//                      '-',
//                      dd
//                    ])}\n${formatDate(endDate, [HH, ':', nn, ':', ss])}",
//                    style: TextStyle(fontSize: 11,color: Colors.white),
//                  ),
//                )
            // ],
            // )
          ],
        ),
      ),
      onTap: onTap,
    ),
  );
}

class RoundedClipper extends CustomClipper<Path> {
  final double height;

  RoundedClipper(this.height);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      height,
      size.width,
      height - 80,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

enum SharedPrefsKeys { TOKEN, USERID }
