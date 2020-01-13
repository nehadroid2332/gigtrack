import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/ui/contactlist/contact_list_presenter.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:swipedetector/swipedetector.dart';

import '../../utils/common_app_utils.dart';

class ContactListScreen extends BaseScreen {
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  ContactListScreen(
    AppListener appListener, {
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState
    extends BaseScreenState<ContactListScreen, ContactListPresenter>
    implements ContactListContract {
  List<Contacts> _contacts = <Contacts>[];

  Stream<List<Contacts>> list;
  final alpha = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];
  ScrollController _controller;
  var _text;
  var _oldtext;
  double _offsetContainer;
  var _sizeheightcontainer;
  var _heightscroller;
  var posSelected = 0;
  var diff = 0.0;
  var txtSliderPos = 0.0;
  var _marginRight = 50.0;
  var _itemsizeheight = 110.0;

  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    list = presenter.getContacts(widget.bandId);
    _searchController.addListener(() {
      setState(() {
        list = presenter.getContacts(widget.bandId,
            contactInit: _searchController.text);
      });
    });
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if ((_controller.offset) >= (_controller.position.maxScrollExtent)) {
      print("reached bottom");
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("reached top");
    }
  }

  _getAlphabetItem(int index) {
    return new Expanded(
      child: new Container(
        width: 40,
        height: 20,
        alignment: Alignment.center,
        child: new Text(
          alpha[index],
          style: (index == posSelected)
              ? new TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              : new TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (_sizeheightcontainer - _heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected =
            ((_offsetContainer / _heightscroller) % alpha.length).round();
        _text = alpha[posSelected];
        if (_text != _oldtext) {
          for (var i = 0; i < _contacts.length; i++) {
            if (_text
                    .toString()
                    .compareTo(_contacts[i].name.toString().toUpperCase()[0]) ==
                0) {
              _controller.jumpTo(i * _itemsizeheight);
              break;
            }
          }
          _oldtext = _text;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
//    var heightAfterToolbar = height - diff;
//    print("height1 $heightAfterToolbar");
//    var remavingHeight = heightAfterToolbar - (20.0 * 26);
//    print("height2 $remavingHeight");
//
//    var reducedheight = remavingHeight / 2;
//    print("height3 $reducedheight");
    _offsetContainer = details.globalPosition.dy - diff;
  }

  _getSpeechBubble() {
    return new SpeechBubble(
      nipLocation: NipLocation.RIGHT,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 30,
            child: Center(
              child: Text(
                "${_text ?? "${alpha.first}"}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  AppBar get appBar => AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.appListener.primaryColorDark,
          ),
          onPressed: () {
            // if (selectedContactInit != null) {
            //   setState(() {
            //     selectedContactInit = null;
            //   });
            // } else {
            Navigator.pop(context);
            // }
          },
        ),
      );

  String selectedContactInit = "";

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: selectedContactInit != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new SvgPicture.asset(
                          'assets/images/telcontact.svg',
                          height: 40.0,
                          width: 40.0,
                          //allowDrawingOutsideViewBox: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          "Contacts",
                          style: textTheme.display1.copyWith(
                              color: Color.fromRGBO(3, 218, 157, 1.0),
                              fontSize: 28,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                    ),
                    Expanded(
                      child: StreamBuilder<List<Contacts>>(
                        stream: list,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            _contacts = snapshot.data;
                            return Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          style: textTheme.button.copyWith(
                                              color: Colors.black,
                                              fontSize: 15),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, constraint) {
                                      diff = height - constraint.biggest.height;
                                      _heightscroller =
                                          (constraint.biggest.height) /
                                              alpha.length;
                                      _sizeheightcontainer =
                                          (constraint.biggest.height); //NO
                                      return Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                            child: ListView.builder(
                                              controller: _controller,
                                              itemCount: _contacts.length,
                                              itemExtent: _itemsizeheight,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final cnt = _contacts[index];
                                                return Container(
                                                  height: MediaQuery.of(context).size.width/3,
                                                  margin: EdgeInsets.all(0),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        //                   <--- left side
                                                        color: Color.fromRGBO(
                                                            3, 218, 157, 1.0),
                                                        width: 1.0,
                                                      ),
                                                      left: BorderSide(
                                                        //                   <--- left side
                                                        color: Colors.white,
                                                        width: 0.0,
                                                      ),
                                                      right: BorderSide(
                                                        //                   <--- left side
                                                        color: Colors.white,
                                                        width: 0.0,
                                                      ),
                                                      top: BorderSide(
                                                        //                   <--- left side
                                                        color: Colors.white,
                                                        width: 0.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: InkWell(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            cnt.files.length > 0
                                                                ? CircleAvatar(
                                                                    radius:
                                                                        30.0,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            cnt.files[0]),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        color: Color.fromRGBO(
                                                                            3,
                                                                            218,
                                                                            157,
                                                                            1.0),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              22,
                                                                          right:
                                                                              22,
                                                                          top:
                                                                              8,
                                                                          bottom:
                                                                              8),
                                                                      child:
                                                                          Text(
                                                                        getNameOrder(
                                                                            cnt.name)[0],
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .yellow,
                                                                            fontSize:
                                                                                32,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontStyle: FontStyle.italic),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                            ),
                                                            cnt.bandId.isEmpty
                                                                ? new Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                  )
                                                                : Container(),
                                                            Expanded(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        top: 26,
                                                                        bottom:
                                                                            15,
                                                                        right:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                          width: cnt.bandId.isNotEmpty
                                                                              ? 0
                                                                              : 0, //
                                                                          color: cnt.bandId.isNotEmpty
                                                                              ? Colors.white
                                                                              : Colors.white //               <--- border width here
                                                                          ),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      getNameOrder(
                                                                          cnt.name), // "${cnt.name.split(" ").reversed.join(' ')}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: textTheme.headline.copyWith(
                                                                          color: cnt.bandId.isNotEmpty
                                                                              ? Colors.black
                                                                              : Colors.black,
                                                                          fontSize: 14),
                                                                    ),
                                                                    cnt.companyName
                                                                            .isNotEmpty
                                                                        ? Text(
                                                                            "${cnt.companyName}",
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: cnt.bandId.isNotEmpty ? Colors.black : Colors.black,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    cnt.bandId
                                                                            .isNotEmpty
                                                                        ? Text(
                                                                            "${cnt.band.name}",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: cnt.bandId.isNotEmpty ? Color.fromRGBO(3, 218, 157, 1.0) : Color.fromRGBO(3, 218, 157, 1.0),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    cnt.relationship.isNotEmpty &&
                                                                            cnt.relationship !=
                                                                                "Select"
                                                                        ? Text(
                                                                            cnt.relationship == "Select"
                                                                                ? " "
                                                                                : cnt.relationship == "Other" ? cnt.otherrelationship : cnt.relationship, // "${cnt.name.split(" ").reversed.join(' ')}",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                textTheme.headline.copyWith(color: cnt.bandId.isNotEmpty ? Colors.black : Colors.black, fontSize: 14),
                                                                          )
                                                                        : Container(),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                    ),
                                                                    cnt.text.isNotEmpty
                                                                        ? Text(
                                                                            cnt.text, // "${cnt.name.split(" ").reversed.join(' ')}",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                textTheme.headline.copyWith(color: cnt.bandId.isNotEmpty ? Colors.black : Colors.black, fontSize: 14),
                                                                          )
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    onTap: (widget.isLeader &&
                                                                widget.bandId
                                                                    .isNotEmpty) ||
                                                            widget
                                                                .bandId.isEmpty
                                                        ? () {
                                                            widget.appListener
                                                                .router
                                                                .navigateTo(
                                                                    context,
                                                                    Screens.ADDCONTACT
                                                                            .toString() +
                                                                        "/${cnt.id}/${widget.bandId.isEmpty ? cnt.bandId : widget.bandId}////");
                                                          }
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            right: _marginRight,
                                            top: _offsetContainer,
                                            child: _getSpeechBubble(),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onVerticalDragUpdate:
                                                  _onVerticalDragUpdate,
                                              onVerticalDragStart:
                                                  _onVerticalDragStart,
                                              child: Container(
                                                //height: 20.0 * 26,
                                                color: Colors.transparent,
                                                child: new Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: []..addAll(
                                                      new List.generate(
                                                          alpha.length,
                                                          (index) =>
                                                              _getAlphabetItem(
                                                                  index)),
                                                    ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error Occured"),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: AppProgressWidget(),
                            );
                          }
                          return Container();
                        },
                      ),
                    )
                  ],
                )
              : SwipeDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: Text("See All"),
                          onPressed: () {
                            setState(() {
                              selectedContactInit = "";
                              list = presenter.getContacts(widget.bandId,
                                  contactInit: selectedContactInit);
                            });
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          "Contacts",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: widget.appListener.primaryColorDark),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Last name starts with...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: widget.appListener.primaryColorDark),
                            ),
                          ),
                          Expanded(
                            child: new Container(
                                alignment: Alignment.bottomCenter,
                                child: Divider(
                                  color: Colors.white,
                                  height: 5,
                                  thickness: 1.5,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),

//            Row(
//              children: <Widget>[
//                Expanded(
//                  child: new Container(
//                    padding: EdgeInsets.only(bottom: 8),
//                      alignment: Alignment.bottomCenter,
//                      margin:
//                      const EdgeInsets.only(left: 10.0, right: 15.0),
//                      child: Divider(
//                        color: Colors.black,
//                        height: 5,
//                        thickness: 1.5,
//                      )),
//                ),
//              ],),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),

                          Expanded(
                            flex: 1,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1.5,
                                )),
                          ),

//                InkWell(onTap: (){
//                  setState(() {
//                    selectedContactInit = "D";
//                    list = presenter.getContacts(widget.bandId,
//                        contactInit: selectedContactInit);
//                  });
//                },
//                  child:Text(
//                    "D",
//                    textAlign: TextAlign.right,
//                    style: TextStyle(
//                        fontSize: 16, fontWeight: FontWeight.bold,color: widget.appListener.primaryColorDark),
//                  ) ,),

//                Expanded(
//                  flex: 1,
//                  child: new Container(
//                      margin:
//                      const EdgeInsets.only(left: 10.0, right: 10.0),
//                      child: Divider(
//                        color: Colors.black,
//                        height: 38,
//                      )),
//                ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Container(
                            height: 38,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 8,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "D";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text(
                              "D",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.appListener.primaryColorDark),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 38,
                                )),
                          ),
                          Container(
                            height: 38,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 38,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 6,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "C";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text("C",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.appListener.primaryColorDark)),
                          ),
                          Expanded(
                            flex: 2,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 5,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "B";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text("B",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.appListener.primaryColorDark)),
                          ),
                          Expanded(
                            flex: 3,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 4,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "A";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text("A",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                          ),
                          Expanded(
                            flex: 4,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 4,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "G";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text("G",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.appListener.primaryColorDark)),
                          ),
                          Expanded(
                            flex: 6,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 2,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "F";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text("F",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.appListener.primaryColorDark)),
                          ),
                          Expanded(
                            flex: 6,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                  height: 36,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            flex: 1,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                  thickness: 1.5,
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "E";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text("E",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.appListener.primaryColorDark)),
                          ),
                          Expanded(
                            flex: 6,
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                  thickness: 1.5,
                                )),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Container(
                            height: 36,
                            width: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          childAspectRatio: 2.20,
                          children: List.generate(alpha.length, (index) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                color: Colors.white,
                                child: Text(
                                  alpha[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          widget.appListener.primaryColorDark),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedContactInit = alpha[index];
                                    list = presenter.getContacts(widget.bandId,
                                        contactInit: selectedContactInit);
                                  });
                                },
                              ),
                            ); //robohash.org api provide you different images for any number you are giving
                          }),
                        ),
                      ),
                      Center(
                          child: Row(
                        verticalDirection: VerticalDirection.up,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "W";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text(
                              "w",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.appListener.primaryColorDark),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "X";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text(
                              "-x",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.appListener.primaryColorDark),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "Y";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text(
                              "-y",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.appListener.primaryColorDark),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedContactInit = "Z";
                                list = presenter.getContacts(widget.bandId,
                                    contactInit: selectedContactInit);
                              });
                            },
                            child: Text(
                              "-z",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.appListener.primaryColorDark),
                            ),
                          )
                        ],
                      )),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                    ],
                  ),
                  onSwipeUp: () {
                    showMessage(("Swipe up"));
                  },
                )),
      floatingActionButton: (widget.isLeader && widget.bandId.isNotEmpty) ||
              widget.bandId.isEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await widget.appListener.router.navigateTo(context,
                    Screens.ADDCONTACT.toString() + "//${widget.bandId}////");
              },
              child: Icon(
                Icons.add,
                color: Color.fromRGBO(3, 218, 157, 1.0),
              ),
              backgroundColor: Colors.yellow,
            )
          : Container(),
    );
  }

  String getNameOrder(String name) {
    List traversedname = name.split(" ");
    int namelength = traversedname.length;
    if (traversedname.length > 1) {
      String lastname = "" + traversedname.last + ", ";
      traversedname.removeLast();
      return lastname + "" + traversedname.join(' ');
    } else {
      return traversedname.last;
    }
  }

  @override
  ContactListPresenter get presenter => ContactListPresenter(this);
}
