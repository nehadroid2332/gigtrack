import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/user.dart';

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
  final searchUsers = <User>[];
  final _searchController = TextEditingController(),
      _stageNameController = TextEditingController(),
      _authController = TextEditingController();
  bool isSearching = false;
  User itemSelect;
  String _errorStageName, _errorAuth;
  final playingStylesList = <String>[
    "All Access",
    "Communications",
    "Post/Edit Activities/Schedules/Tasks",
    "View Only",
    "Post/Edit Equipment",
    "Post/Edit About the Band"
  ];
  final memberRoles = <String>[
    "Agent",
    "Manager",
    "Musician",
    "Roodle",
    "Back up Musician"
  ];
  final instruments = <String>[
    "Bass",
    "Drums",
    "Guitar",
    "Keys",
    "Piano",
    "Percussions",
    "Vocals-Lead",
    "Vocals-Harmony",
  ];
  final others = <String>[
    "Equipment Manager",
    "Communications",
    "Marketing",
    "Button"
  ];
  final Set<String> psList = Set();
  String mList, iList, oList;

  @override
  Widget buildBody() {
    List<Widget> items = [];
    for (String s in playingStylesList) {
      items.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: psList.contains(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: psList.contains(s)
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
            if (psList.contains(s)) {
              psList.remove(s);
            } else
              psList.add(s);
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
                color: mList == (s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: mList == (s)
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
            mList = s;
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
              ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                  ),
                )
              : Container(),
          itemSelect == null
              ? FlatButton(
                  child: Text("Search"),
                  onPressed: () {
                    presenter.searchUser(_searchController.text);
                  },
                )
              : Container(),
          Expanded(
            child: isSearching
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : itemSelect == null
                    ? ListView.builder(
                        itemCount: searchUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          User user = searchUsers[index];
                          return ListTile(
                            title: Text("${user.firstName} ${user.lastName}"),
                            subtitle: Text(user.primaryInstrument),
                            trailing: FlatButton(
                              child: Text(
                                "Select",
                                style: textTheme.button.copyWith(
                                  color: widget.appListener.primaryColorDark,
                                ),
                              ),
                              color: Color.fromRGBO(244, 246, 248, 1.0),
                              onPressed: () {
                                setState(() {
                                  itemSelect = user;
                                });
                              },
                            ),
                          );
                        },
                      )
                    : ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                                "${itemSelect.firstName} ${itemSelect.lastName}"),
                            subtitle: Text(itemSelect.primaryInstrument),
                          ),
                          TextField(
                            controller: _stageNameController,
                            decoration: InputDecoration(
                              labelText: "Stage Name",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorStageName,
                            ),
                          ),
                          TextField(
                            controller: _authController,
                            decoration: InputDecoration(
                              labelText: "Authentication Field",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorAuth,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          FlatButton(
                            child: Text(
                              "Pay Info",
                              style: textTheme.button.copyWith(
                                color: widget.appListener.primaryColorDark,
                              ),
                            ),
                            color: Color.fromRGBO(244, 246, 248, 1.0),
                            onPressed: () {},
                          ),
                          Text(
                            "Permissions",
                            style: textTheme.headline.copyWith(
                              color: Color.fromRGBO(99, 108, 119, 1.0),
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Padding(padding: EdgeInsets.all(10)),
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
                                Text(
                                  "Member Role",
                                  style: textTheme.headline.copyWith(
                                    color: Color.fromRGBO(99, 108, 119, 1.0),
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(padding: EdgeInsets.all(3)),
                                Wrap(
                                  children: items2,
                                ),
                                Divider(),
                                Text(
                                  "Instruments",
                                  style: textTheme.headline.copyWith(
                                    color: Color.fromRGBO(99, 108, 119, 1.0),
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(padding: EdgeInsets.all(3)),
                                Wrap(
                                  children: items3,
                                ),
                                Divider(),
                                Text(
                                  "Other",
                                  style: textTheme.headline.copyWith(
                                    color: Color.fromRGBO(99, 108, 119, 1.0),
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(padding: EdgeInsets.all(3)),
                                Wrap(
                                  children: items4,
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              showLoading();
                              presenter.addMemberToBand(
                                  BandMember(
                                    user_id: itemSelect.id,
                                    authField: _authController.text,
                                    instrument: iList,
                                    memberRole: mList,
                                    other: oList,
                                    payInfo: null,
                                    permissions: List.from(psList),
                                    stageName: _stageNameController.text,
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
  void onSearchUser(List<User> users) {
    setState(() {
      searchUsers.clear();
      searchUsers.addAll(users);
    });
  }
}
