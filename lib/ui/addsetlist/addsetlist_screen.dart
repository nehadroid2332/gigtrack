import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/setlist.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

import 'addsetlist_presenter.dart';

class AddSetListScreen extends BaseScreen {
  final String id;
  AddSetListScreen(AppListener appListener, {this.id})
      : super(appListener, title: "");

  @override
  _AddSetListScreenState createState() => _AddSetListScreenState();
}

class _AddSetListScreenState
    extends BaseScreenState<AddSetListScreen, AddSetListPresenter>
    implements AddSetListContract {
  bool isEdit = false;
  final _listNameController = TextEditingController(),
      _songArtistController = TextEditingController(),
      _songChordsController = TextEditingController(),
      _songNameController = TextEditingController();
  String _listNameError, _songNameError, _songArtistError, _songChordsError;
  List _fruits = ["Learning", "1 week away", "1 month away", "Ready", "Other"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<Song> _songList = [];
  Song currentSong;
  String _selectedFruit;

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List fruits) {
    List<DropdownMenuItem<String>> items = List();
    for (String fruit in fruits) {
      items.add(DropdownMenuItem(value: fruit, child: Text(fruit)));
    }
    return items;
  }

  void changedDropDownItem(String selectedFruit) {
    setState(() {
      _selectedFruit = selectedFruit;
      if (currentSong != null) {
        currentSong.perform = selectedFruit;
      }
    });
  }

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_fruits);
    _selectedFruit = _dropDownMenuItems[0].value;
    super.initState();
  }

  @override
  AppBar get appBar => AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (currentSong != null) {
              setState(() {
                currentSong = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: Color.fromRGBO(214, 22, 35, 1.0),
        actions: <Widget>[],
      );
  @override
  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: RoundedClipper(height / 2.5),
          child: Container(
            color: Color.fromRGBO(214, 22, 35, 1.0),
            height: height / 2.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.id.isEmpty ? "Add" : ""} BulletIn Board",
                style: textTheme.display2
                    .copyWith(color: Colors.white, fontSize: 30),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: currentSong != null
                      ? ListView(
                          padding: EdgeInsets.all(10),
                          children: <Widget>[
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      errorText: _songNameError,
                                      labelText: widget.id.isEmpty || isEdit
                                          ? "Song Name"
                                          : "",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                    controller: _songNameController,
                                  )
                                : Text(
                                    _songNameController.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      errorText: _songArtistError,
                                      labelText: widget.id.isEmpty || isEdit
                                          ? "Artist"
                                          : "",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                    controller: _songArtistController,
                                  )
                                : Text(
                                    _songArtistController.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    enabled: widget.id.isEmpty || isEdit,
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      errorText: _songChordsError,
                                      labelText: widget.id.isEmpty || isEdit
                                          ? "Chords"
                                          : "",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                      border: widget.id.isEmpty || isEdit
                                          ? null
                                          : InputBorder.none,
                                    ),
                                    controller: _songChordsController,
                                  )
                                : Text(
                                    _songChordsController.text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text(
                              "Ready to Perform",
                              style: textTheme.subtitle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            DropdownButton(
                              value: _selectedFruit,
                              items: _dropDownMenuItems,
                              onChanged: changedDropDownItem,
                              underline: Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                            ),
                            widget.id.isEmpty || isEdit
                                ? RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (currentSong != null) {
                                          currentSong.artist =
                                              _songArtistController.text;
                                          currentSong.chords =
                                              _songChordsController.text;
                                          currentSong.name =
                                              _songNameController.text;
                                          _songList.add(currentSong);
                                          currentSong = null;
                                          _selectedFruit =
                                              _dropDownMenuItems[0].value;
                                          _songArtistController.clear();
                                          _songChordsController.clear();
                                          _songNameController.clear();
                                        }
                                      });
                                    },
                                    color: Color.fromRGBO(214, 22, 35, 1.0),
                                    child: Text(
                                      "Submit",
                                      style: textTheme.headline.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    textColor: Colors.white,
                                  )
                                : Container()
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              widget.id.isEmpty || isEdit
                                  ? TextField(
                                      enabled: widget.id.isEmpty || isEdit,
                                      style: textTheme.title,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        errorText: _listNameError,
                                        labelText: widget.id.isEmpty || isEdit
                                            ? "Set-List Name"
                                            : "",
                                        labelStyle: TextStyle(
                                          color: Color.fromRGBO(
                                              202, 208, 215, 1.0),
                                        ),
                                        border: widget.id.isEmpty || isEdit
                                            ? null
                                            : InputBorder.none,
                                      ),
                                      controller: _listNameController,
                                    )
                                  : Text(
                                      _listNameController.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Song List",
                                      style: textTheme.title,
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text("Add Song"),
                                    onPressed: () {
                                      setState(() {
                                        currentSong = Song();
                                        currentSong.perform = _selectedFruit;
                                      });
                                    },
                                  )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _songList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Song song = _songList[index];
                                    return ListTile(
                                      title: Text(song.name),
                                      subtitle: Text(song.artist),
                                    );
                                  },
                                ),
                              ),
                              widget.id.isEmpty || isEdit
                                  ? RaisedButton(
                                      onPressed: () {
                                        showLoading();
                                        SetList setList = SetList();
                                        setList.setListName =
                                            _listNameController.text;
                                        setList.songs = _songList;
                                        presenter.addSetList(setList);
                                      },
                                      color: Color.fromRGBO(214, 22, 35, 1.0),
                                      child: Text(
                                        "Submit",
                                        style: textTheme.headline.copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      textColor: Colors.white,
                                    )
                                  : Container()
                            ],
                          ),
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
  AddSetListPresenter get presenter => AddSetListPresenter(this);

  @override
  void onSuccess() {
    if (!mounted) return;
    hideLoading();
    showMessage("Created Successfully");
    Navigator.of(context).pop();
  }

  @override
  void onUpdate() {
    hideLoading();
  }
}
