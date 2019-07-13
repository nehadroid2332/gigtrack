import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/ui/instrumentlist/instrument_list_presenter.dart';

class InstrumentListScreen extends BaseScreen {
  InstrumentListScreen(AppListener appListener)
      : super(appListener, title: "Equipment  List");

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
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: _instruments.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          final instr = _instruments[index];
          DateTime purchasedDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(instr.purchased_date));

          return Card(
            margin: EdgeInsets.all(10),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${instr.name}",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text("Purchased"),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Date: ${formatDate(purchasedDate, [
                              yyyy,
                              '-',
                              mm,
                              '-',
                              dd
                            ])} ${formatDate(purchasedDate, [
                              HH,
                              ':',
                              nn,
                              ':',
                              ss
                            ])}",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "From: ${instr.purchased_from}",
                            style: TextStyle(fontSize: 11),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                widget.appListener.router.navigateTo(
                    context, Screens.ADDINSTRUMENT.toString() + "/${instr.id}");
              },
            ),
          );
        },
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
