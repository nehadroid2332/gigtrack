import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/utils/common_app_utils.dart';
import 'addmembertobandpresenter.dart';

class AddMemberToBandScreen extends BaseScreen {
  final String bandId;
  final String id;

  AddMemberToBandScreen(AppListener appListener, {this.bandId, this.id})
      : super(appListener, title: "Add band Member");

  @override
  _AddMemberToBandScreenState createState() => _AddMemberToBandScreenState();
}

class _AddMemberToBandScreenState
    extends BaseScreenState<AddMemberToBandScreen, AddMemberToBandPresenter>
    implements AddMemberToBandContract {
  final searchUsers = <Contacts>[];
  bool isPrimary = false;
  final _searchController = TextEditingController(),
      _firstNameController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _emailController = TextEditingController(),
      _emergencyContactTextController = TextEditingController(),
      _otherTalentController = TextEditingController(),
      _mobileTextController = TextEditingController(),
      _notesController = TextEditingController(),
      _primaryContactTextController = TextEditingController(),
      _payController = TextEditingController();
  bool isSearching = false;
  Contacts itemSelect;
  String _errorFirstName,
      _errorLastName,
      _errorMobileText,
      _errorPrimaryContact,
      _errorEmergencyContact,
      _errorPay,
      _errorNotes,
      _errorOtherTalent,
      _errorEmail;

  final playingStylesList = <String>[
    "Leader", //all access
    "Communications", //only create/edit notes,rest only read     all users can read all
    "Setup", // add bandmember,rest only read
    // "Post Entries"
  ];
  final memberRoles = <String>[
    "Agent",
    "Manager",
    "Musician",
    "Roadie",
    "Equipment Manager",
    "Communications",
    "Marketing",
  ];
  final instrumentList = <String>[
    "Guitar-Lead",
    "Guitar-Rhythm",
    "Bass",
    "Drums",
    "Keys",
    "Piano",
    "Harmonica",
    "Vocals-Lead",
    "Vocals-Harmony"
  ];
  final instruments = <String>[];
  final others = <String>[];
  final Set<String> mList = Set();
  final Set<String> inList = Set();
  String psList, iList, oList;

  bool isEdit = false;

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (isEdit) {
              final check = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Do you want to save changes?"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("No",style: TextStyle(color: Colors.black87),),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      RaisedButton(
                        child: Text("Yes"),
                        color: widget.appListener.accentColor,
                        onPressed: () {
                          _submit();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
              if (check) {
                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: widget.id.isEmpty
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2,
            child: Text(
              "Add Band Member",
              textAlign: TextAlign.center,
              style: textTheme.headline.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                ),
          widget.id.isEmpty
              ? Container()
              : IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    _showDialogConfirm();
                  },
                )
        ],
      );

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.id.isNotEmpty) {
      showLoading();
      presenter.getBandMemberDetails(widget.bandId, id: widget.id);
    } else {
      presenter.getBandMemberDetails(widget.bandId);
    }
  }

  bool qDarkmodeEnable = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    checkThemeMode();
  }

  void checkThemeMode() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var qdarkMode = MediaQuery.of(context).platformBrightness;
      if (qdarkMode == Brightness.dark) {
        setState(() {
          qDarkmodeEnable = true;
        });
      } else {
        setState(() {
          qDarkmodeEnable = false;
        });
      }
    }
  }

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
          onTap: widget.id.isEmpty || isEdit
              ? () {
                  setState(() {
                    psList = s;
                  });
                }
              : null));
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
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (mList.contains(s)) {
                    mList.remove(s);
                  } else
                    mList.add(s);
                });
              }
            : null,
      ));
    }
    List<Widget> items6 = [];
    for (String s in instrumentList) {
      items6.add(GestureDetector(
        child: Container(
          child: Text(
            s,
            style: textTheme.subtitle.copyWith(
                color: inList.contains(s)
                    ? Colors.white
                    : widget.appListener.primaryColorDark),
          ),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: inList.contains(s)
                ? widget.appListener.primaryColorDark
                : Color.fromRGBO(244, 246, 248, 1.0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color.fromRGBO(228, 232, 235, 1.0),
            ),
          ),
        ),
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  if (inList.contains(s)) {
                    inList.remove(s);
                  } else
                    inList.add(s);
                });
              }
            : null,
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
        onTap: widget.id.isEmpty || isEdit
            ? () {
                setState(() {
                  oList = s;
                });
              }
            : null,
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
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: .5),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      color: Colors.black26,
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.black),
                      ),
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
                                title: Text(
                                  "${user.name}",
                                  style: TextStyle(
                                      color: qDarkmodeEnable
                                          ? Colors.black87
                                          : Colors.black87),
                                ),
                                subtitle: Text(
                                  user.relationship,
                                  style: TextStyle(
                                      color: qDarkmodeEnable
                                          ? Colors.black87
                                          : Colors.black87),
                                ),
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
                              child: Text(
                                "Click to Add Member",
                                style: TextStyle(color: Colors.black),
                              ),
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
                            enabled: widget.id.isEmpty || isEdit,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Name",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorFirstName,
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
//                          TextField(
//                            controller: _lastNameController,
//                            enabled: widget.id.isEmpty || isEdit,
//                            decoration: InputDecoration(
//                              labelText: "Last Name",
//                              labelStyle: TextStyle(
//                                color: Color.fromRGBO(169, 176, 187, 1.0),
//                              ),
//                              errorText: _errorLastName,
//                            ),
//                          ),
                          TextField(
                            controller: _mobileTextController,
                            enabled: widget.id.isEmpty || isEdit,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              // Fit the validating format.
                              phoneNumberFormatter,
                            ],
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Mobile/Text",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorMobileText,
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                          (widget.id.isNotEmpty &&
                                      presenter.primaryContactEmail == null) ||
                                  (widget.id.isEmpty &&
                                      presenter.primaryContactEmail == null) ||
                                  (widget.id.isNotEmpty &&
                                      presenter.primaryContactEmail ==
                                          _emailController.text)
                              ? Row(
                                  children: <Widget>[
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Colors.grey,
                                      ),
                                      child: Checkbox(
                                        onChanged: (widget.id.isEmpty || isEdit)
                                            ? (bool value) {
                                                setState(() {
                                                  isPrimary = value;
                                                });
                                              }
                                            : null,
                                        checkColor: Colors
                                            .yellowAccent, // color of tick Mark
                                        activeColor: isPrimary
                                            ? Colors.black87
                                            : Colors.grey,
                                        value: isPrimary,
                                      ),
                                    ),
                                    Text(
                                      "Make Primary Contact",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    )
                                  ],
                                )
                              : Container(),
//                          TextField(
//                            controller: _primaryContactTextController,
//                            enabled: widget.id.isEmpty || isEdit,
//                            decoration: InputDecoration(
//                              labelText: "Primary Contact",
//                              labelStyle: TextStyle(
//                                color: Color.fromRGBO(169, 176, 187, 1.0),
//                              ),
//                              errorText: _errorPrimaryContact,
//                            ),
//                          ),
                          Column(
                            children: <Widget>[
                              TextField(
                                controller: _emailController,
                                enabled: widget.id.isEmpty,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: .5),
                                  ),
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                    color: Color.fromRGBO(169, 176, 187, 1.0),
                                  ),
                                  errorText: _errorEmail,
                                ),
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),

                          TextField(
                            controller: _emergencyContactTextController,
                            enabled: widget.id.isEmpty || isEdit,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Emergency Contact",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorEmergencyContact,
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextField(
                            controller: _primaryContactTextController,
                            enabled: widget.id.isEmpty || isEdit,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              // Fit the validating format.
                              phoneNumberFormatter,
                            ],
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Emergency Contact Phone",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorPrimaryContact,
                            ),
                            style: TextStyle(color: Colors.black87),
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
                          Text("Instruments",
                              style: textTheme.headline.copyWith(
                                color: Color.fromRGBO(99, 108, 119, 1.0),
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left),
                          Padding(padding: EdgeInsets.all(5)),
                          Wrap(
                            children: items6,
                          ),
                          Divider(),
                          TextField(
                            controller: _otherTalentController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Other Talent",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorOtherTalent,
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Notes",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorNotes,
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextField(
                            controller: _payController,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: .5),
                              ),
                              labelText: "Pay Percentage",
                              labelStyle: TextStyle(
                                color: Color.fromRGBO(169, 176, 187, 1.0),
                              ),
                              errorText: _errorPay,
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),

                          Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 4,
                                right: MediaQuery.of(context).size.width / 4,
                                top: 10),
                            child: FlatButton(
                              onPressed: () {
                                _submit();
                              },
                              child: Text(
                                "Submit",
                              ),
                              color: widget.appListener.primaryColor,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
      if (users.length == 0) {
        showMessage("No User Found");
      }
    });
  }

  @override
  void bandMemberDetails(BandMember bandMember, String primaryContactEmail) {
    setState(() {
      hideLoading();
      itemSelect = Contacts();
      _firstNameController.text = bandMember.firstName;
      _lastNameController.text = bandMember.lastName;
      _mobileTextController.text = bandMember.mobileText;
      _notesController.text = bandMember.notes;
      _emailController.text = bandMember.email;
      isPrimary = bandMember.email == primaryContactEmail;
      _otherTalentController.text = bandMember.otherTalent;
      _payController.text = bandMember.pay;
      _primaryContactTextController.text = bandMember.primaryContact;
      psList = bandMember.permissions;
      iList = bandMember.instrument;
      mList.addAll(bandMember.memberRole);
      inList.addAll(bandMember.instrumentList);
    });
  }

  void _showDialogConfirm() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: new Text(
            "Warning",
            textAlign: TextAlign.center,
          ),
          content: Text("Are you sure you want to delete?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Yes"),
              textColor: Colors.black,
              color: Colors.white,
              onPressed: () {
                if (widget.id == null || widget.id.isEmpty) {
                  showMessage("Id cannot be null");
                } else {
                  presenter.deleteMemberFromBand(widget.bandId, id: widget.id);
                  hideLoading();
                  //Navigator.pop(context,"band");
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
            new RaisedButton(
              child: new Text("No"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              color: Color.fromRGBO(99, 108, 119, 1.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    String emailText = _emailController.text;
    if (emailText.isEmpty) {
      _errorEmail = "Cannot be Empty";
    } else {
      showLoading();
      presenter.addMemberToBand(
          BandMember(
              user_id: itemSelect.user_id,
              // instrument: iList,
              memberRole: List.from(mList),
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              emergencyContact: _emergencyContactTextController.text,
              mobileText: _mobileTextController.text,
              other: oList,
              primaryContact: _primaryContactTextController.text,
              payInfo: null,
              pay: _payController.text,
              otherTalent: _otherTalentController.text,
              notes: _notesController.text,
              permissions: (psList),
              instrumentList: List.from(inList)),
          widget.bandId,
          isPrimary);
    }
  }
}
