import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/ui/contactlist/contact_list_presenter.dart';

class ContactListScreen extends BaseScreen {
  ContactListScreen(AppListener appListener) : super(appListener);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState
    extends BaseScreenState<ContactListScreen, ContactListPresenter> {
  final _contacts = <String>[];

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
              "Contacts Lists",
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
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final bnd = _contacts[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${bnd}",
                              style: textTheme.headline.copyWith(
                                color: widget.appListener.primaryColorDark,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
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
                        widget.appListener.router.navigateTo(
                            context, Screens.ADDCONTACT.toString() + "/${bnd}");
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
              .navigateTo(context, Screens.ADDCONTACT.toString() + "/");
          // showLoading();
          // presenter.getBands();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  ContactListPresenter get presenter => ContactListPresenter(this);
}
