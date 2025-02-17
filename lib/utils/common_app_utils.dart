import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/utils/UsNumberTextInputFormatter.dart';

UsNumberTextInputFormatter phoneNumberFormatter = UsNumberTextInputFormatter();

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

Widget buildActivityListItem(Activites ac, context, isCalendar,
    {bool showConfirm = false, onConfirmPressed, onTap, bool isPast = false}) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(ac.startDate).toLocal();
  return Row(
    children: <Widget>[
      isCalendar
          ? Container()
          : Column(
              children: <Widget>[
                Container(
                  color: Colors.grey,
                  width: 1.2,
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  width: MediaQuery.of(context).size.width / 6.8,
                  child: Text(
                    "${formatDate(dt, [
                      DD,
                      '\n',
                      M,
                      ' ',
                      d,
                      ', ',
                      yyyy,
                    ])}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color.fromRGBO(32, 95, 139, 1.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: 1.2,
                  height: 50,
                ),
              ],
            ),
      Container(
        width: isCalendar
            ? MediaQuery.of(context).size.width / 1.2
            : MediaQuery.of(context).size.width / 1.5,
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(),
        child: InkWell(
          child: Container(
            padding: ac.bandId.isNotEmpty
                ? EdgeInsets.symmetric(vertical: 5)
                : EdgeInsets.symmetric(vertical: 10),
            decoration: ac.bandId.isEmpty
                ? BoxDecoration(
                    color: Color.fromRGBO(40, 35, 188, 0.2),
                    border: Border.all(width: 1, color: Colors.blue))
                : BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: isCalendar
                                ? Color.fromRGBO(3, 54, 255, 1.0)
                                : Colors.transparent,
                            width: 1.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ac.startTime != null
                        ? Text(
                            "${ac.startTime.toLowerCase()}",
                            style: TextStyle(
                                color: Color.fromRGBO(32, 95, 139, 1.0),
                                fontSize: 16),
                          )
                        : Container(),
                    ac.endTime.isNotEmpty
                        ? Text(
                            " - ${ac.endTime.toLowerCase()}",
                            style: TextStyle(
                                color: Color.fromRGBO(32, 95, 139, 1.0),
                                fontSize: 16),
                          )
                        : Container()
                  ],
                ),
                Text(
                  "${ac.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ac.bandId.isNotEmpty
                        ? isPast
                            ? Colors.grey
                            : Color.fromRGBO(40, 35, 188, 1.0)
                        : isPast
                            ? Colors.grey
                            : Color.fromRGBO(40, 35, 188, 1.0),
                  ),
                  textAlign: TextAlign.center,
                ),
                new Container(
                    padding:
                        EdgeInsets.only(left: 0, right: 0, top: 3, bottom: 3),
                    alignment: Alignment.bottomCenter,
                    child: Divider(
                      color: isCalendar
                          ? Colors.transparent
                          : Color.fromRGBO(3, 54, 255, 1.0),
                      height: isCalendar ? 0 : 5,
                      thickness: 1.5,
                    )),
                ac.band != null
                    ? Text(
                        currentType(ac.type) + "-" + (ac?.band?.name ?? ''),
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          color: ac.bandId.isNotEmpty
                              ? isPast
                                  ? Colors.grey
                                  : Color.fromRGBO(32, 95, 139, 1.0)
                              : isPast
                                  ? Colors.grey
                                  : Color.fromRGBO(40, 35, 188, 1.0),
                        ),
                        textAlign: ac.bandId.isNotEmpty
                            ? TextAlign.right
                            : TextAlign.center,
                      )
                    : Text(
                        currentType(ac.type),
                        style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          color: ac.bandId.isNotEmpty
                              ? isPast
                                  ? Colors.grey
                                  : Color.fromRGBO(32, 95, 139, 1.0)
                              : isPast
                                  ? Colors.grey
                                  : Color.fromRGBO(40, 35, 188, 1.0),
                        ),
                        textAlign: ac.bandId.isNotEmpty
                            ? TextAlign.right
                            : TextAlign.center,
                      )
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    ],
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
  } else if (type == 4) {
    return "Band Task";
  } else if (type == 5) {
    return "Appointment";
  }
  return "";
}

Widget buildNoteListItem(NotesTodo not, Color color, {onTap}) {
  DateTime stDate = DateTime.fromMillisecondsSinceEpoch((not.startDate));
  DateTime endDate = DateTime.fromMillisecondsSinceEpoch((not.endDate));

  return Card(
    margin: EdgeInsets.all(10),
    color:
        not.bandId.isNotEmpty ? Colors.white : Color.fromRGBO(3, 54, 255, 1.0),
    shape: RoundedRectangleBorder(
      side: not.bandId.isNotEmpty
          ? new BorderSide(color: Color.fromRGBO(3, 54, 255, 1.0), width: 1.0)
          : new BorderSide(color: Color.fromRGBO(3, 54, 255, 1.0), width: 1.0),
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
                  color: (not.bandId.isNotEmpty)
                      ? Color.fromRGBO(3, 54, 255, 1.0)
                      : Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(3),
            ),
            not.band != null ? Text("${not.band.name}") : Container(),
            Padding(
              padding: EdgeInsets.all(3),
            ),
            not.startDate == 0
                ? Container()
                : Text(
                    not.startDate == 0
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
                      color: (not.bandId.isNotEmpty)
                          ? Color.fromRGBO(3, 54, 255, 1.0)
                          : Colors.white,
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
              "${not.type}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3),
            ),
            Text(
              "${not.item}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              "${not.description}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: EdgeInsets.all(3),
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
                      fontSize: 14,
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

double initScale({Size imageSize, Size size, double initialScale}) {
  var n1 = imageSize.height / imageSize.width;
  var n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    Size destinationSize = fittedSizes.destination;
    return size.height / destinationSize.height;
  }

  return initialScale;
}

class AspectRatioItem {
  final String text;
  final double value;

  AspectRatioItem({this.value, this.text});
}

class AppProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/images/loadingimage.gif',
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
        ],
      ),
    );
  }
}

String getNameOrder(String name) {
  name = name.trim();
  List traversedname = name.split(" ");
  int namelength = traversedname.length;
  if (traversedname.length > 1) {
    String lastname = "" + traversedname.last + ", ";
    traversedname.removeLast();
    return lastname + "" + traversedname.join(' ');
  } else {
    return traversedname.last;
  }
}


class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered = false, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.blueAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: !isMe ? 65.0 : 55),
                child: Text(message),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    !isMe
                        ? Icon(
                            icon,
                            size: 12.0,
                            color: Colors.black38,
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

final _base64SafeEncoder = const Base64Codec.urlSafe();

String encodeStringToBase64UrlSafeString(final String url) =>
    _base64SafeEncoder.encode(utf8.encode(url));

String decodeFromBase64UrlSafeEncodedString(String str) =>
    utf8.decode(_base64SafeEncoder.decode(str));
