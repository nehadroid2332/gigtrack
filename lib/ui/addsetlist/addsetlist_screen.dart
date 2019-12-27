import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/setlist.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'package:random_string/random_string.dart';
import '../../server/models/band_member.dart';
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
      _songNotesController = TextEditingController(),
      _songNameController = TextEditingController();
  final Map<String, String> inList = Map();
  final instrumentList = <String>[
    "Ready to perform",
    "Needs work",
    "New Song",
  ];
  String _listNameError,
      _songNameError,
      _songArtistError,
      _songChordsError,
      _songNoteserror;
  List _fruits = ["Ready", "Needs work", "New song"];
  List<Song> _songList = [];
  Song currentSong;

  String _selectedFruit;
  final _subNoteFieldController = TextEditingController();

  List<SetList> setLists = [];

  List<BandMember> bandmembers = [];

  @override
  void initState() {
    super.initState();
    if (widget.id != null &&
        widget.id.isNotEmpty &&
        widget.userId != null &&
        widget.userId.isNotEmpty) {
      showLoading();
      presenter.getDetails(widget.id, widget.userId);
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
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (currentSong != null) {
                      setState(() {
                        _songList.removeWhere((s) {
                          return s.id == currentSong.id;
                        });
                        currentSong = null;
                      });
                    } else if (widget.id == null || widget.id.isEmpty) {
                      showMessage("Id cannot be null");
                    } else {
                      _showDialogConfirm();
                      // presenter.instrumentDelete(id);
                      // Navigator.of(context).pop();
                    }
                  },
                )
        ],
      );

  void _showDialogConfirm() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: new Text(
            "Warning",
            textAlign: TextAlign.center,
          ),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Yes"),
              textColor: Colors.black,
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  showLoading();
                  presenter.deleteSetList(widget.id);
                  Navigator.of(context).pop();
                }
              },
            ),
            new RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(214, 22, 35, 1.0),
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  if (_selectedFruit == (s)) {
                    _selectedFruit = null;
                  } else
                    _selectedFruit = s;
                });
              }
            : null,
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
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      errorText: _songNameError,
                                      labelText: "Song Name",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                    ),
                                    controller: _songNameController,
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      _songNameController.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : RaisedButton(
                                    onPressed: () {
                                      addSongNotes();
                                    },
                                    child: Text("Practice Now"),
                                  ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : Text("Players"),
                            widget.id.isEmpty || isEdit
                                ? Container()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: bandmembers.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final members = bandmembers[index];
                                      return ListTile(
                                        title: Text(
                                            "${members.firstName} ${members.lastName}"),
                                        subtitle: Text("${members.memberRole}"),
                                      );
                                    },
                                  ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      errorText: _songArtistError,
                                      labelText: "Artist",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                    ),
                                    controller: _songArtistController,
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      _songArtistController.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      errorText: _songChordsError,
                                      labelText: "Chords",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                    ),
                                    controller: _songChordsController,
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      _songChordsController.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.all(6),
                            ),
//                            Text(
//                              "Ready to Perform",
//                              style: textTheme.subtitle.copyWith(
//                                fontSize: 16,
//                              ),
//                            ),
                            
                            Center(child:Wrap(
                              children: items,
                            ) ,),
                           
                            Padding(
                              padding: EdgeInsets.all(0),
                            ),
  
                            RaisedButton(
                              onPressed:() {},
                                color: Color.fromRGBO(214, 22, 35, 1.0),
                                child: Text(
                                    "Play now",
                                    style: textTheme.headline.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textColor: Colors.white,
                            ),
                            widget.id.isEmpty || isEdit
                                ? TextField(
                                    style: textTheme.title,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      errorText: _songNoteserror,
                                      labelText: "Notes",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(202, 208, 215, 1.0),
                                      ),
                                    ),
                                    controller: _songNotesController,
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      _songNotesController.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Song Notes"),
                                ),
                                widget.id.isEmpty || isEdit
                                    ? Container()
                                    : IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          addSongNotes();
                                        },
                                      )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: currentSong?.subnotes?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                SongNotes subnote =
                                    currentSong?.subnotes[index];
                                return ListTile(
                                  title: Text("${subnote.title}"),
                                );
                              },
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
                                          currentSong.notes =
                                              _songNotesController.text;
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
                                          _songNotesController.clear();
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
                                              _songNotesController.clear();
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
                                      onTap: () {
                                        setState(() {
                                          currentSong = song;
                                          currentSong.subnotes.sort((a, b) {
                                            return b.time.compareTo(a.time);
                                          });
                                          _songArtistController.text =
                                              currentSong.artist;
                                          _songChordsController.text =
                                              currentSong.chords;
                                          _songNameController.text =
                                              currentSong.name;
                                          _songNotesController.text =
                                              currentSong.notes;
                                          _selectedFruit = song.perform;
                                        });
                                      },
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
    presenter.getDetails(widget.id, widget.userId);
  }

  @override
  void onDetails(SetList setList) {
    hideLoading();
    setState(() {
      _songList = setList.songs;
      _listNameController.text = setList.setListName;
    });
  }

  @override
  void onDelete() {}

  @override
  void onBandMemberDetails(Iterable<BandMember> values) {
    setState(() {
      bandmembers.clear();
      bandmembers.addAll(values);
    });
  }

  void addSongNotes() {
    if (widget.id.isEmpty || isEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Song notes'),
              content: TextField(
                controller: _subNoteFieldController,
                decoration: InputDecoration(hintText: "Enter song notes..."),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('SUBMIT'),
                  onPressed: () {
                    if (_subNoteFieldController.text.isNotEmpty)
                      setState(() {
                        currentSong.subnotes.add(SongNotes(
                          time: DateTime.now().millisecondsSinceEpoch,
                          title: _subNoteFieldController.text,
                        ));
                        presenter.addSong(widget.id, currentSong);
                      });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
