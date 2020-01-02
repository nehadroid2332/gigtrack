import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';

import '../../server/models/error_response.dart';
import '../../server/models/user_playing_style.dart';
import '../../server/models/user_playing_style.dart';

abstract class AddPlayingStyleContract extends BaseContract {
  void onAddSuccess();
  void onUpdateSuccess();
  void onDetailsSuccess(UserPlayingStyle userPlayingStyle);

  void onDelete();

  void getBandDetails(Band res);

  void onUserDetailsSuccess(User res);

  void addBandExtra();
}

class AddPlayingStylePresenter extends BasePresenter {
  AddPlayingStylePresenter(BaseContract view) : super(view);

  void addPlayingStyle(UserPlayingStyle userPlayingStyle) async {
    userPlayingStyle.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addUserPlayingStyle(userPlayingStyle);
    if (res is bool) {
      if (res)
        (view as AddPlayingStyleContract).onUpdateSuccess();
      else
        (view as AddPlayingStyleContract).onAddSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getbandDetails(String id) async {
    final res = await serverAPI.getBandDetails(id);
    if (res is Band) {
      (view as AddPlayingStyleContract).getBandDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getPlayingStyleDetails(String id) async {
    final res = await serverAPI.getPlayingStyleDetails(id);
    if (res is UserPlayingStyle) {
      (view as AddPlayingStyleContract).onDetailsSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deletePlayingStyle(String id) async {
    await serverAPI.deletePlayingStyle(id);
    (view as AddPlayingStyleContract).onDelete();
  }

  void getUserProfile() async {
    final res = await serverAPI.getSingleUserById(serverAPI.currentUserId);
    if (res is User) {
      (view as AddPlayingStyleContract).onUserDetailsSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addBandExtra(BandDetails bandDetails, String id, bool isUpdate) async {
    final res = await serverAPI.getPlayingStyleDetails(id);
    if (res is UserPlayingStyle) {
      if (isUpdate) {
        for (var i = 0; i < res.bandDetails.length; i++) {
          BandDetails bandDetails1 = res.bandDetails[i];
          if (bandDetails1.id == bandDetails.id) {
            res.bandDetails[i] = bandDetails1;
          }
        }
      } else {
        res.bandDetails.add(bandDetails);
      }
      await serverAPI.addUserPlayingStyle(res);
      (view as AddPlayingStyleContract).addBandExtra();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
