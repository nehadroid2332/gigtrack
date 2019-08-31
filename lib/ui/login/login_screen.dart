
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/login/login_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class LoginScreen extends BaseScreen {
  LoginScreen(AppListener appListener) : super(appListener);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreen, LoginPresenter>
    implements LoginContract {
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController();
  String _errorEmail, _errorPassword;

  @override
  Widget buildBody() {
    return Container(
        decoration: new BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/guitar_splash.png'),
            fit: BoxFit.cover,
          ),
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment
                .bottomCenter, // 10% of the width, so there are ten blinds.
            colors: [
              widget.appListener.primaryColor,
              widget.appListener.accentColor
            ], //tish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
            ),
            Expanded(
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/logo.png',
                        alignment: Alignment.centerLeft,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Text(
                      "Sign In to Continue",
                      style: textTheme.title.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        errorText: _errorEmail,
                      ),
                      style: textTheme.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorText: _errorPassword),
                      obscureText: true,
                      style: textTheme.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        RaisedButton(
                          color: Color.fromRGBO(255, 0, 104, 1.0),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Sign In",
                                style: textTheme.title.copyWith(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 19,
                              )
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              if (email.isEmpty) {
                                _errorEmail = "Cannot be empty";
                              } else if (password.isEmpty) {
                                _errorPassword = "Cannot be empty";
                              } else if (validateEmail(email)) {
                                _errorEmail = "Not a Valid Email";
                              } else if (password.length < 6) {
                                _errorPassword =
                                    "Password must be more than 6 character";
                              } else {
                                showLoading();
                                presenter.loginUser(email, password);
                              }
                            });
                          },
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          textColor: Colors.white,
                          onPressed: () {
                            widget.appListener.router
                                .navigateTo(context, Screens.FORGOTPASSWORD.toString());
                          },
                          child: Text(
                            "Forgot Password",
                            style: textTheme.subtitle.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          textColor: Colors.white,
                          onPressed: () {
                            widget.appListener.router
                                .navigateTo(context, Screens.SIGNUP.toString());
                          },
                          child: Text(
                            "New User? Sign Up",
                            style: textTheme.subtitle.copyWith(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  @override
  LoginPresenter get presenter => LoginPresenter(this);

  @override
  void loginSuccess(String token, String userId) async {
    await widget.appListener.sharedPreferences
        .setString(SharedPrefsKeys.TOKEN.toString(), token);
    await widget.appListener.sharedPreferences
        .setString(SharedPrefsKeys.USERID.toString(), userId);
    presenter.addLogin(
        widget.appListener.sharedPreferences
            .getString(SharedPrefsKeys.USERID.toString()),
        widget.appListener.sharedPreferences
            .getString(SharedPrefsKeys.TOKEN.toString()));
    hideLoading();
    widget.appListener.router.navigateTo(
      context,
      Screens.DASHBOARD.toString(),
      replace: true,
      transition: TransitionType.inFromRight,
    );
  }
}
