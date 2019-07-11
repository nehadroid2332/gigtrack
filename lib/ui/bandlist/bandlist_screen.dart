import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/ui/bandlist/bandlist_presenter.dart';

class BandListScreen extends BaseScreen {
  BandListScreen(AppListener appListener)
      : super(appListener, title: "Band List");

  @override
  _BandListScreenState createState() => _BandListScreenState();
}

class _BandListScreenState
    extends BaseScreenState<BandListScreen, BandListPresenter>
    implements BandListContract {
  final _bands = <Band>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getBands();
    });
  }

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: _bands.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          final bnd = _bands[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${bnd.name}",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      "Music Style: ${bnd.musicStyle}",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                widget.appListener.router.navigateTo(
                    context, Screens.ADDBAND.toString() + "/${bnd.id}");
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDBAND.toString() + "/");
          showLoading();
          presenter.getBands();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  BandListPresenter get presenter => BandListPresenter(this);

  @override
  void onBandList(List<Band> bands) {
    if (!mounted) return;
    hideLoading();
    setState(() {
      this._bands.clear();
      this._bands.addAll(bands);
    });
  }
}
