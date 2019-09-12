import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/notestodo.dart';

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
    {bool showConfirm = false, onConfirmPressed, onTap}) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(ac.startDate);
  return Card(
    color: Color.fromRGBO(235, 84, 99, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Text(
                "${formatDate(dt, [D, '-', mm, '/', dd, '/', yy, ' -'])}",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(250, 250, 250, 1.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Expanded(
                child: Text(
                  "${ac.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(250, 250, 250, 1.0),
                  ),
                ),
              ),
            ]),
            showConfirm
                ? Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: onConfirmPressed,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      onTap: onTap,
    ),
  );
}

Widget buildNoteListItem(NotesTodo not, Color color, {onTap}) {
  DateTime stDate = DateTime.fromMillisecondsSinceEpoch((not.start_date));
  DateTime endDate = DateTime.fromMillisecondsSinceEpoch((not.end_date));

  return Card(
    margin: EdgeInsets.all(10),
    color: Color.fromRGBO(105, 114, 98, 1.0),
    child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${not.description}",
              style: TextStyle(
                fontSize: 24,
                color: color,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/calender.png',
                  height: 20,
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Expanded(
                  child: Text(
                    "${formatDate(stDate, [
                      yyyy,
                      '-',
                      mm,
                      '-',
                      dd
                    ])}\n${formatDate(stDate, [HH, ':', nn, ':', ss])}",
                    style: TextStyle(fontSize: 12,color: Colors.white),
                  ),
                ),
                Image.asset(
                  'assets/images/calender.png',
                  height: 20,
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Expanded(
                  child: Text(
                    "${formatDate(endDate, [
                      yyyy,
                      '-',
                      mm,
                      '-',
                      dd
                    ])}\n${formatDate(endDate, [HH, ':', nn, ':', ss])}",
                    style: TextStyle(fontSize: 11,color: Colors.white),
                  ),
                )
              ],
            )
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
