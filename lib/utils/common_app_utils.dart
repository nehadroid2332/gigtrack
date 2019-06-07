import 'package:flutter/material.dart';

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

enum SharedPrefsKeys { TOKEN, USERID }
