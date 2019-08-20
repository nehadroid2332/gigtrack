import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
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
  final _searchController = TextEditingController();
  bool isSearching = false;

  @override
  Widget buildBody() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    presenter.searchUser(_searchController.text);
                  })
            ],
          ),
          Expanded(
            child: isSearching
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: searchUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = searchUsers[index];
                      return ListTile(
                        title: Text("${user.firstName} ${user.lastName}"),
                        subtitle: Text(user.primaryInstrument),
                        onTap: () {
                          showLoading();
                          presenter.addMemberToBand(widget.id, user.id);
                        },
                      );
                    },
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
