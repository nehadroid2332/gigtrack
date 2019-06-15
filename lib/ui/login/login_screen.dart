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
        color: Color.fromRGBO(240, 243, 244, 0.5),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  child: Text(
                    "SignIn",
                    style: textTheme.headline,
                    textAlign: TextAlign.center,
                  ),
                  alignment: Alignment.center,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            Expanded(
              child: Card(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    Icon(
                      Icons.import_contacts,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Email",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hintText: "Enter Email",
                          errorText: _errorEmail),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Password",
                        style: textTheme.subhead.copyWith(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: "Enter Password",
                          errorText: _errorPassword),
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      child: Text("Login"),
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () {
                        widget.appListener.router
                            .navigateTo(context, Screens.SIGNUP.toString());
                      },
                      child: Text("Sign Up"),
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
  void loginSuccess(String token, String userId) {
    widget.appListener.sharedPreferences
        .setString(SharedPrefsKeys.TOKEN.toString(), token);
    widget.appListener.sharedPreferences
        .setString(SharedPrefsKeys.USERID.toString(), userId);
    hideLoading();
    widget.appListener.router.navigateTo(
      context,
      Screens.DASHBOARD.toString(),
      replace: true,
      transition: TransitionType.inFromRight,
    );
  }
}
