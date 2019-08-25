import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_presenter.dart';

class InstrumentListScreen extends BaseScreen {
  InstrumentListScreen(AppListener appListener) : super(appListener, title: "");

  @override
  _InstrumentListScreenState createState() => _InstrumentListScreenState();
}

class _InstrumentListScreenState
    extends BaseScreenState<InstrumentListScreen, InstrumentListPresenter>
    implements InstrumentListContract {
  final _instruments = <Instrument>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getInstruments();
    });
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
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Equipment Lists",
              style: textTheme.display1.copyWith(
                  color: widget.appListener.primaryColorDark,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _instruments.length,
                itemBuilder: (BuildContext context, int index) {
                  final instr = _instruments[index];
                  DateTime purchasedDate = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(instr.purchased_date));

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${instr.name}",
                              style: textTheme.headline.copyWith(
                                color: widget.appListener.primaryColorDark,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
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
                      onTap: () {
                        widget.appListener.router.navigateTo(context,
                            Screens.ADDINSTRUMENT.toString() + "/${instr.id}");
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDINSTRUMENT.toString() + "/");
          showLoading();
          presenter.getInstruments();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  InstrumentListPresenter get presenter => InstrumentListPresenter(this);

  @override
  void getInstruments(List<Instrument> list) {
    if (!mounted) return;
    hideLoading();
    setState(() {
      _instruments.clear();
      _instruments.addAll(list);
    });
  }
}
