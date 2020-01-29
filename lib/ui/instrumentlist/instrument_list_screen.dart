import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user_instrument.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_presenter.dart';

import '../../utils/common_app_utils.dart';

class InstrumentListScreen extends BaseScreen {
  final String bandId;
  final bool isLeader;
  final bool isComm;
  final bool isSetUp;
  final bool postEntries;

  InstrumentListScreen(
    AppListener appListener, {
    this.bandId,
    this.isLeader,
    this.isComm,
    this.isSetUp,
    this.postEntries,
  }) : super(appListener, title: "");

  @override
  _InstrumentListScreenState createState() => _InstrumentListScreenState();
}

class _InstrumentListScreenState
    extends BaseScreenState<InstrumentListScreen, InstrumentListPresenter>
    implements InstrumentListContract {
  List<UserInstrument> _instruments = <UserInstrument>[];

  Stream<List<UserInstrument>> list;

  String bandName;

  @override
  void initState() {
    super.initState();
    list = presenter.getList(widget.bandId);
    presenter.getBand(widget.bandId);
  }

  @override
  AppBar get appBar => AppBar(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.appListener.primaryColorDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${bandName ?? ""}",
          style: textTheme.title.copyWith(
            color: Colors.blueAccent,
          ),
        ),
      );

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                new SvgPicture.asset(
                  "assets/images/radioicon.svg",
                  height: 45.0,
                  width: 45.0,
                  //allowDrawingOutsideViewBox: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Equipment",
                  style: textTheme.display1.copyWith(
                      color: Colors.deepOrangeAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: StreamBuilder<List<UserInstrument>>(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _instruments = snapshot.data;

                    return ListView.builder(
                      itemCount: _instruments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final instr = _instruments[index];
                        DateTime purchasedDate =
                            DateTime.fromMillisecondsSinceEpoch(
                                (instr.purchased_date));

                        return Card(
                          color: (instr.bandId.isNotEmpty)
                              ? Colors.white
                              : Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                              side: instr.bandId.isNotEmpty
                                  ? new BorderSide(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0)
                                  : new BorderSide(
                                      color: Colors.deepOrangeAccent,
                                      width: 1.0),
                              borderRadius: BorderRadius.circular(16)),
                          child: InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 0, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  instr.uploadedFiles != null &&
                                          instr.uploadedFiles.length > 0
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  File(instr.uploadedFiles[0])
                                                      .path,
                                                ),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                            border: Border(
                                              bottom: BorderSide(
                                                //                   <--- left side
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              left: BorderSide(
                                                //                   <--- left side
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              right: BorderSide(
                                                //                   <--- left side
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              top: BorderSide(
                                                //                   <--- left side
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4.4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: null
//                                    Image.network(
//                                      File(instr.uploadedFiles[0]).path,
//                                      fit: BoxFit.cover,
//                                    ),
                                          )
                                      : Container(),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                  ),
                                  Center(
                                    child: Text(
                                      "${instr.name}",
                                      style: textTheme.headline.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: (instr.bandId.isNotEmpty)
                                              ? Colors.black
                                              : Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Center(
                                    child: instr.band != null
                                        ? Text(
                                            "${instr.band.name}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )
                                        : Container(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                  ),
//                            Text(
//                              "Purchased",
//                              style: textTheme.subhead.copyWith(
//                                color: Color.fromRGBO(235, 84, 99, 1.0),
//                              ),
//                            ),
//                            Text(
//                              "Date: ${formatDate(purchasedDate, [
//                                yyyy,
//                                '-',
//                                mm,
//                                '-',
//                                dd
//                              ])} ${formatDate(purchasedDate, [
//                                HH,
//                                ':',
//                                nn,
//                                ':',
//                                ss
//                              ])}",
//                              style: TextStyle(fontSize: 11),
//                            ),
//                            Text(
//                              "From: ${instr.purchased_from}",
//                              style: TextStyle(fontSize: 11),
//                            )
                                ],
                              ),
                            ),
                            onTap:
                                (widget.isLeader && widget.bandId.isNotEmpty) ||
                                        widget.bandId.isEmpty
                                    ? () {
                                        widget.appListener.router.navigateTo(
                                            context,
                                            Screens.ADDINSTRUMENT.toString() +
                                                "/${instr.id}/${widget.bandId.isEmpty ? instr.bandId : widget.bandId}////");
                                      }
                                    : null,
                          ),
                        );
                      },
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
        ),
      ),
      floatingActionButton:
          (widget.bandId != null && widget.isLeader) || widget.bandId.isEmpty
              ? FloatingActionButton(
                  onPressed: () async {
                    await widget.appListener.router.navigateTo(
                        context,
                        Screens.ADDINSTRUMENT.toString() +
                            "//${widget.bandId}////");
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromRGBO(3, 54, 255, 1.0),
                )
              : Container(),
    );
  }

  @override
  InstrumentListPresenter get presenter => InstrumentListPresenter(this);

  @override
  void onBandDetails(Band res) {
    setState(() {
      bandName = res.name;
    });
  }
}
