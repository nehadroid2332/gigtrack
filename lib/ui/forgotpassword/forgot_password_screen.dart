import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/forgotpassword/forgot_password_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class ForgotPasswordScreen extends BaseScreen {
  ForgotPasswordScreen(AppListener appListener)
      : super(appListener, title: "Forgot Password");

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends BaseScreenState<ForgotPasswordScreen, ForgotPasswordPresenter>
    implements ForgotPasswordContract {
  final _emailController = TextEditingController();
  String _errorEmail;
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
                        height: 120,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(20),
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
                                "Submit",
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
                              if (email.isEmpty) {
                                _errorEmail = "Cannot be empty";
                              } else if (validateEmail(email)) {
                                _errorEmail = "Not a Valid Email";
                              } else {
                                showLoading();
                                presenter.forgotPassword(email);
                              }
                            });
                          },
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  @override
  ForgotPasswordPresenter get presenter => ForgotPasswordPresenter(this);

  @override
  void onSuccess() {
    // TODO: implement onSuccess
  }
}
