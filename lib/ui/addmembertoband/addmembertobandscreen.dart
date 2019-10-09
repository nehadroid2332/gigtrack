import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/contacts.dart';

import 'addmembertobandpresenter.dart';

class AddMemberToBandScreen extends BaseScreen {
  final String id;

  AddMemberToBandScreen(AppListener appListener, {this.id})
      : super(appListener, title: "Add band Member");

  @override
  _AddMemberToBandScreenState createState() => _AddMemberToBandScreenState();
}

class _AddMemberToBandScreenState
    extends BaseScreenState<AddMemberToBandScreen, AddMemberToBandPresenter>
    implements AddMemberToBandContract {
  final searchUsers = <Contacts>[];
  final _searchController = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _emailController = TextEditingController(),
      _otherTalentController = TextEditingController(),
      _mobileTextController = TextEditingController(),
      _notesController = TextEditingController(),
      _payController = TextEditingController();
  bool isSearching = false;
  Contacts itemSelect;
  String _errorFirstName,
      _errorLastName,
      _errorMobileText,
      _errorPay,
      _errorNotes,
      _errorOtherTalent,
      _errorEmail;
  final playingStylesList = <String>[
    "Leader",//all access
    "Communications",//only create/edit notes,rest only read     all users can read all
    "Setup",// add bandmember,rest only read
    // "Post Entries"
  ];
  final memberRoles = <String>[
    "Agent",
    "Manager",
    "Musician",
    "Roodle",
    "Back up Musician",
    "Bass",
    "Drums",
    "Guitar",
    "Keys",
    "Piano",
    "Percussions",
    "Vocals-Lead",
    "Vocals-Harmony",
    "Equipment Manager",
    "Communications",
    "Marketing",
    "Button"
  ];
  final instruments = <String>[];
  final others = <String>[];
  final Set<String> mList = Set();
  String psList, iList, oList;

  @override
  Widget buildBody() {
    List<Widget> items = [];
    for (String s in playingStylesList) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: psList == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: psList == s
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            psList = s;
          });
        },
      ));
    }
    List<Widget> items2 = [];
    for (String s in memberRoles) {
      items2.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: mList.contains(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: mList.contains(s)
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            if (mList.contains(s)) {
              mList.remove(s);
            } else
              mList.add(s);
          });
        },
      ));
    }
    List<Widget> items3 = [];
    for (String s in instruments) {
      items3.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: iList == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: iList == (s)
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            iList = s;
          });
        },
      ));
    }
    List<Widget> items4 = [];
    for (String s in others) {
      items4.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: oList == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: oList == (s)
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            oList = s;
          });
        },
      ));
    }
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          itemSelect == null
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                        ),
                      ),
                    ),
                    FlatButton(
                      child: Text("Search"),
                      onPressed: () {
                        presenter.searchUser(_searchController.text);
                      },
                    )
                  ],
                )
              : Container(),
          Expanded(
            child: isSearching
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : itemSelect == null
                    ? searchUsers.length > 0
                        ? ListView.builder(
                            itemCount: searchUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contacts user = searchUsers[index];
                              return ListTile(
                                title: Text("${user.name}"),
                                subtitle: Text(user.relationship),
                                trailing: FlatButton(
                                  child: Text(
                                    "Select",
                                    style: textTheme.button.copyWith(
                                      color:
                                          widget.appListener.primaryColorDark,
                                    ),
                                  ),
                                  color: Color.fromRGBO(244, 246, 248, 1.0),
                                  onPressed: () {
                                    setState(() {
                                      itemSelect = user;
                                      _emailController.text = itemSelect.email;
                                      _firstNameController.text =
                                          itemSelect.name;
                                      _mobileTextController.text =
                                          itemSelect.text;
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        : Center(
                            child: FlatButton(
                              child: Text("Click to Add Member"),
                              onPressed: () {
                                setState(() {
                                  itemSelect = Contacts();
                                });
                              },
                            ),
                          )
                    : ListView(
                        children: <Widget>[
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorFirstName,
                            ),
                          ),
                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorLastName,
                            ),
                          ),
                          TextField(
                            controller: _mobileTextController,
                            decoration: InputDecoration(
                              labelText: "Mobile/Text",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorMobileText,
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorEmail,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          // FlatButton(
                          //   child: Text(
                          //     "Pay Info",
                          //     style: textTheme.button.copyWith(
                          //       color: widget.appListener.primaryColorDark,
                          //     ),
                          //   ),
                          //   color: Color.fromRGBO(244, 246, 248, 1.0),
                          //   onPressed: () {},
                          // ),
                          Text(
                            "Permissions",
                            style: textTheme.headline.copyWith(
                              color: Color.fromRGBO(99, 108, 119, 1.0),
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Wrap(
                            children: items,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                          ),
                          Text(
                            "Primary Role",
                            style: textTheme.headline.copyWith(
                              color: Color.fromRGBO(99, 108, 119, 1.0),
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Text(
                                //   "Member Role",
                                //   style: textTheme.headline.copyWith(
                                //     color: Color.fromRGBO(99, 108, 119, 1.0),
                                //     fontSize: 15,
                                //   ),
                                //   textAlign: TextAlign.left,
                                // ),
                                Padding(padding: EdgeInsets.all(3)),
                                Wrap(
                                  children: items2,
                                ),
                                Divider(),
                                // Text(
                                //   "Instruments",
                                //   style: textTheme.headline.copyWith(
                                //     color: Color.fromRGBO(99, 108, 119, 1.0),
                                //     fontSize: 15,
                                //   ),
                                //   textAlign: TextAlign.left,
                                // ),
                                // Padding(padding: EdgeInsets.all(3)),
                                // Wrap(
                                //   children: items3,
                                // ),
                                // Divider(),
                                // Text(
                                //   "Other",
                                //   style: textTheme.headline.copyWith(
                                //     color: Color.fromRGBO(99, 108, 119, 1.0),
                                //     fontSize: 15,
                                //   ),
                                //   textAlign: TextAlign.left,
                                // ),
                                // Padding(padding: EdgeInsets.all(3)),
                                // Wrap(
                                //   children: items4,
                                // ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: _otherTalentController,
                            decoration: InputDecoration(
                              labelText: "Other Talent",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorOtherTalent,
                            ),
                          ),
                          TextField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              labelText: "Notes",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorNotes,
                            ),
                          ),
                          TextField(
                            controller: _payController,
                            decoration: InputDecoration(
                              labelText: "Pay Percentage",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorPay,
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              showLoading();
                              presenter.addMemberToBand(
                                  BandMember(
                                    user_id: itemSelect.user_id,
                                    // instrument: iList,
                                    memberRole: List.from(mList),
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    mobileText: _mobileTextController.text,
                                    other: oList,
                                    payInfo: null,
                                    pay: _payController.text,
                                    otherTalent: _otherTalentController.text,
                                    notes: _notesController.text,
                                    permissions: (psList),
                                  ),
                                  widget.id);
                            },
                            child: Text(
                              "Submit",
                            ),
                            color: Color.fromRGBO(255, 0, 104, 1.0),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          )
                        ],
                      ),
          )
        ],
      ),
    );
  }

  @override
  AddMemberToBandPresenter get presenter => AddMemberToBandPresenter(this);

  @override
  void onMemberAdd() {
    hideLoading();
    Navigator.pop(context);
  }

  @override
  void onSearchUser(List<Contacts> users) {
    setState(() {
      searchUsers.clear();
      searchUsers.addAll(users);
    });
  }
}
