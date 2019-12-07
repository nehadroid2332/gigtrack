import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/setlist.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:random_string/random_string.dart';
import 'addsetlist_presenter.dart';

class AddSetListScreen extends BaseScreen {
  final String id;
  final String userId;
  AddSetListScreen(AppListener appListener, {this.id, this.userId})
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
  final Map<String, String> inList = Map();
  final instrumentList = <String>[
    "Ready to play",
    "Needs work",
    "New Song",
  ];
  String _listNameError, _songNameError, _songArtistError, _songChordsError;
  List _fruits = ["Ready to play", "needs work", "new song"];
  List<Song> _songList = [];
  Song currentSong;
  String _selectedFruit;

  List<SetList> setLists = [];

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.id.isNotEmpty) {
      showLoading();
      presenter.getDetails(widget.id);
    }
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
        actions: <Widget>[
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                ),
        ],
      );
  @override
  Widget buildBody() {
    List<Widget> items2 = [];
    for (String s in instrumentList) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: inList.containsKey(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: inList.containsKey(s)
                ? Color.fromRGBO(214, 22, 35, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (inList.containsKey(s)) {
                    inList.remove(s);
                  } else
                    inList[s] = null;
                });
              }
            : null,
      ));
    }
    List<Widget> items = [];
    for (String s in _fruits) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: _selectedFruit == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: _selectedFruit == (s)
                ? Color.fromRGBO(124, 180, 97, 1.0)
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (_selectedFruit == (s)) {
              _selectedFruit = null;
            } else
              _selectedFruit = s;
          });
        },
      ));
    }

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
                "${widget.id.isEmpty ? "Add" : ""} Set List",
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
                            TextField(
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                errorText: _songNameError,
                                labelText: "Song Name",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                              controller: _songNameController,
                            ),
                            TextField(
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                errorText: _songArtistError,
                                labelText: "Artist",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                              controller: _songArtistController,
                            ),
                            TextField(
                              style: textTheme.title,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                errorText: _songChordsError,
                                labelText: "Chords",
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(202, 208, 215, 1.0),
                                ),
                              ),
                              controller: _songChordsController,
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
                            Wrap(
                              children: items,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                            ),
//                            (widget.id.isEmpty || isEdit)
//                                ? Wrap(
//                              children: items2,
//                            )
//                                : Container(),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  if (currentSong != null) {
                                    currentSong.artist =
                                        _songArtistController.text;
                                    currentSong.chords =
                                        _songChordsController.text;
                                    currentSong.name = _songNameController.text;
                                    currentSong.perform = _selectedFruit;
                                    if (currentSong.id == null) {
                                      currentSong.id = randomString(15);
                                      _songList.add(currentSong);
                                    } else {
                                      for (var i = 0;
                                          i < _songList.length;
                                          i++) {
                                        Song song = _songList[i];
                                        if (song.id == currentSong.id) {
                                          _songList[i] = currentSong;
                                          break;
                                        }
                                      }
                                    }
                                    currentSong = null;
                                    _selectedFruit = null;
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
                                          TextCapitalization.words,
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
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Song List",
                                      style: textTheme.title,
                                    ),
                                  ),
                                  widget.id.isEmpty || isEdit
                                      ? RaisedButton(
                                          child: Text("Add Song"),
                                          onPressed: () {
                                            setState(() {
                                              currentSong = Song();
                                              _songNameController.clear();
                                              _songChordsController.clear();
                                              _songArtistController.clear();
                                              _selectedFruit = null;
                                              currentSong.perform =
                                                  _selectedFruit;
                                            });
                                          },
                                        )
                                      : Container()
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
                                      onTap: isEdit
                                          ? () {
                                              setState(() {
                                                currentSong = song;
                                                _songArtistController.text =
                                                    currentSong.artist;
                                                _songChordsController.text =
                                                    currentSong.chords;
                                                _songNameController.text =
                                                    currentSong.name;
                                                _selectedFruit = song.perform;
                                              });
                                            }
                                          : null,
                                    );
                                  },
                                ),
                              ),
                              widget.id.isEmpty || isEdit
                                  ? RaisedButton(
                                      onPressed: () {
                                        showLoading();
                                        SetList setList = SetList();
                                        setList.id = widget.id;
                                        setList.setListName =
                                            _listNameController.text;
                                        setList.songs = _songList;
                                        setList.user_id = widget.userId;
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

  @override
  void onDetails(SetList setList) {
    hideLoading();
    setState(() {
      _songList = setList.songs;
      _listNameController.text = setList.setListName;
    });
  }
}
