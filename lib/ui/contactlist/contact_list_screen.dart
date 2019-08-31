
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/ui/contactlist/contact_list_presenter.dart';

class ContactListScreen extends BaseScreen {
  ContactListScreen(AppListener appListener) : super(appListener);

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState
    extends BaseScreenState<ContactListScreen, ContactListPresenter>
    implements ContactListContract {
  final _contacts = <Contacts>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoading();
      presenter.getContacts();
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
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Row(children: <Widget>[
            Image.asset(
              'assets/images/contact_color.png',
              height: 40,
              width: 40,
            ),
            Padding(padding: EdgeInsets.only(left: 15),),
            Text(
              "Contacts",
              style: textTheme.display1.copyWith(
                  color: Color.fromRGBO(82, 149, 171, 1.0),
                  fontSize: 28,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ],),
            Padding(
              padding: EdgeInsets.all(4),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final cnt = _contacts[index];
                  return Card(
                    color: Color.fromRGBO(82, 149, 171, 1.0),
                    margin: EdgeInsets.all(6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${cnt.name}",
                              style: textTheme.headline.copyWith(
                                color: Colors.white,
                                fontSize: 18
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
                            Screens.ADDCONTACT.toString() + "/${cnt.id}");
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
        backgroundColor: Color.fromRGBO(82, 149, 171, 1.0),
      ),
    );
  }

  @override
  ContactListPresenter get presenter => ContactListPresenter(this);

  @override
  void onContactListSuccess(List<Contacts> contacts) {
    hideLoading();
    setState(() {
      this._contacts.clear();
      this._contacts.addAll(contacts);
    });
  }
}
