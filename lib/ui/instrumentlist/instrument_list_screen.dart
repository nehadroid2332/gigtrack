import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/user_instrument.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_presenter.dart';

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

  @override
  void initState() {
    super.initState();
    list = presenter.getList(widget.bandId);
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
            Navigator.pop(context);
          },
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
                Image.asset(
                  'assets/images/equipment_color.png',
                  height: 45,
                  width: 45,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Equipment",
                  style: textTheme.display1.copyWith(
                      color: Color.fromRGBO(191, 53, 42, 1.0),
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
                  }
                  return ListView.builder(
                    itemCount: _instruments.length,
                    itemBuilder: (BuildContext context, int index) {
                      final instr = _instruments[index];
                      DateTime purchasedDate =
                          DateTime.fromMillisecondsSinceEpoch(
                              (instr.purchased_date));

                      return Card(
                        color: (instr.bandId.isNotEmpty)?Colors.white:Color.fromRGBO(191, 53, 42, 1.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: InkWell(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${instr.name}",
                                  style: textTheme.headline.copyWith(
                                      fontSize: 18, color:(instr.bandId.isNotEmpty)?Color.fromRGBO(191, 53, 42, 1.0): Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                              "/${instr.id}/${widget.bandId}////");
                                    }
                                  : null,
                        ),
                      );
                    },
                  );
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
                  backgroundColor: Color.fromRGBO(191, 53, 42, 1.0),
                )
              : Container(),
    );
  }

  @override
  InstrumentListPresenter get presenter => InstrumentListPresenter(this);
}
