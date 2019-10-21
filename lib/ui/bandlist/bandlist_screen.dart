import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/ui/bandlist/bandlist_presenter.dart';

class BandListScreen extends BaseScreen {
  BandListScreen(AppListener appListener) : super(appListener, title: "");

  @override
  _BandListScreenState createState() => _BandListScreenState();
}

class _BandListScreenState
    extends BaseScreenState<BandListScreen, BandListPresenter>
    implements BandListContract {
  List _bands = <Band>[];
  Stream<List<Band>> list;

  @override
  void initState() {
    super.initState();
    list = presenter.getBands();
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
                  'assets/images/band_color.png',
                  height: 40,
                  width: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                Text(
                  "Bands",
                  style: textTheme.display1.copyWith(
                      color: Color.fromRGBO(239,181, 77, 1.0),
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
              child: StreamBuilder(
                stream: list,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    _bands = snapshot.data;
                  }
                  return ListView.builder(
                    itemCount: _bands.length,
                    itemBuilder: (BuildContext context, int index) {
                      final bnd = _bands[index];
                      return Card(
                        margin: EdgeInsets.all(6),
                        color: Color.fromRGBO(239,181, 77, 1.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${bnd.name.toString()}",
                                  style: textTheme.headline.copyWith(
                                      color: Color.fromRGBO(135, 67, 125, 1.0),
                                      fontSize: 18,
                                    
                                  ),
                                  
                                  
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                ),
//                            Text(
//                              "${bnd.musicStyle}",
//                              style: TextStyle(
//                                fontSize: 14,
//                                color: Color.fromRGBO(149, 121, 218, 1.0),
//                              ),
//                            ),
                              ],
                            ),
                          ),
                          onTap: () {
                            widget.appListener.router.navigateTo(context,
                                Screens.ADDBAND.toString() + "/${bnd.id}");
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.appListener.router
              .navigateTo(context, Screens.ADDBAND.toString() + "/");
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(239,181, 77, 1.0),
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
