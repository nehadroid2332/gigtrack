
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/addsong/add_song_presenter.dart';

class AddSongScreen extends BaseScreen {
  AddSongScreen(AppListener appListener) : super(appListener);

  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState
    extends BaseScreenState<AddSongScreen, AddSongPresenter>
    implements AddSongContract {
  final _songNameController = TextEditingController(),
      _bandNameController = TextEditingController(),
      _keyController = TextEditingController(),
      _yearController = TextEditingController(),
      _aboutController = TextEditingController();

  String _errorSongName, _errorBandName, _errorKey, _errorYear, _errorAbout;

  @override
  Widget buildBody() {
    return Container(
      color: Color.fromRGBO(240, 243, 244, 0.5),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Align(
                child: Text(
                  "Add Song",
                  style: textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Done",
                      style: textTheme.button,
                    ),
                  ),
                  onTap: () {
                    widget.appListener.router.navigateTo(
                      context,
                      Screens.DASHBOARD.toString(),
                      replace: true,
                      transition: TransitionType.inFromRight,
                    );
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Song",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _songNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Song",
                        errorText: _errorSongName),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Band",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _bandNameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Band",
                        errorText: _errorBandName),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Key",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _keyController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Key",
                        errorText: _errorKey),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Year",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _yearController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Year",
                        errorText: _errorYear),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "About",
                      style: textTheme.subhead.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _aboutController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "About",
                        errorText: _errorAbout),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  RaisedButton(
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        String sname = _songNameController.text;
                        String bname = _bandNameController.text;
                        String key = _keyController.text;
                        String year = _yearController.text;
                        String about = _aboutController.text;
                        _errorAbout = null;
                        _errorBandName = null;
                        _errorKey = null;
                        _errorSongName = null;
                        _errorYear = null;

                        if (sname.isEmpty) {
                          _errorSongName = "Cannot be Empty";
                        } else if (bname.isEmpty) {
                          _errorBandName = "Cannot be Empty";
                        } else if (key.isEmpty) {
                          _errorKey = "Cannot be Empty";
                        } else if (year.isEmpty) {
                          _errorYear = "Cannot be Empty";
                        } else if (about.isEmpty) {
                          _errorYear = "Cannot be Empty";
                        } else {
                          showLoading();
                          presenter.addSong();
                        }
                      });
                    },
                    child: Text("Add"),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  AddSongPresenter get presenter => AddSongPresenter(this);

  @override
  void onSongSuccess() {
    hideLoading();
    setState(() {
      _songNameController.clear();
      _bandNameController.clear();
      _keyController.clear();
      _yearController.clear();
      _aboutController.clear();
      _errorAbout = null;
      _errorBandName = null;
      _errorKey = null;
      _errorSongName = null;
      _errorYear = null;
    });
  }
}
