import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addfeedback/add_feedback_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class AddFeedbackScreen extends BaseScreen {
  AddFeedbackScreen(AppListener appListener) : super(appListener);

  @override
  _AddFeedbackScreenState createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState
    extends BaseScreenState<AddFeedbackScreen, AddFeedbackPresenter>
    implements AddFeedbackContract {
  String _feedbackError;
  final _feedbackController = TextEditingController();

  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 4.5),
          child: Container(
            color: Color.fromRGBO(255, 215, 0, 1.0),
            height: height / 4.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                
                "Your Feedback means a lot to us, what do you think?",
                style: textTheme.display2
                    .copyWith(color: Colors.black, fontSize: 26,fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(0),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      TextField(
                        style: textTheme.title,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          errorText: _feedbackError,
                          labelText: "Add Feedback",
                          labelStyle: TextStyle(
                            color: Colors.black//Color.fromRGBO(202, 208, 215, 1.0),
                          ),
                          //border: InputBorder.none,
                        ),
                        controller: _feedbackController,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      RaisedButton(
                        onPressed: () {
                          String feed = _feedbackController.text;
                          if (feed.isEmpty) {
                            _feedbackError = "Cannot be Empty";
                          } else {
                            showLoading();
                            presenter.addFeedback(feed);
                          }
                        },
                        color:Color.fromRGBO(255, 215, 0, 1.0), //Color.fromRGBO(22, 102, 237, 1.0),
                        child: Text(
                          "Submit",
                          style: textTheme.headline.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textColor: Colors.black,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  AppBar get appBar => AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor:Color.fromRGBO(255, 215, 0, 1.0),
      );

  @override
  AddFeedbackPresenter get presenter => AddFeedbackPresenter(this);

  @override
  void onSuccess() {
    hideLoading();
    showMessage("Thank you so much for your feedback!");
    Timer timer = new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
