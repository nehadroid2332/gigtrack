import 'dart:io';

import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class ProfileContract extends BaseContract {
  void onUserProfile(User user);
  void onUpdate();
}

class ProfilePresenter extends BasePresenter {
  ProfilePresenter(BaseContract view) : super(view);

  void getUserProfile() async {
    final res = await serverAPI
        .getSingleUserById((await serverAPI.getCurrentUser()).uid);
    if (res is User) {
      (view as ProfileContract).onUserProfile(res);
    } else {
      view.showMessage(res);
    }
  }

  void updateUserProfile(
      String fname,
      String lname,
      String email,
      String password,
      String phone,
      String address,
      String city,
      String state,
      String zip,
      File image,
      String primaryInstrument) async {
    final res = await serverAPI
        .getSingleUserById((await serverAPI.getCurrentUser()).uid);
    if (res is User) {
      res.firstName = fname;
      res.lastName = lname;
      res.phone = phone;
      res.zipcode = zip;
      res.address = address;
      res.city = city;
      res.state = state;
      if (image != null) {
        res.profilePic = image.path;
      }
      await serverAPI.updateUserProfile(res);
      (view as ProfileContract).onUpdate();
    } else {
      view.showMessage(res);
    }
  }
}
