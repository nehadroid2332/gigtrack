import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/ui/addplayingstyle/add_playing_style_presenter.dart';

abstract class AddBandContract extends BaseContract {
  void addBandSuccess();
  void onUpdate();
  void getBandDetails(Band band);
  void onData(List<UserPlayingStyle> acc);
  void onUserDetailsSuccess(User res);
}

class AddBandPresenter extends BasePresenter {
  AddBandPresenter(BaseContract view) : super(view);

  void addBand(
      int dateStarted,
      String musicStyle,
      String bname,
      String blname,
      String legalstructure,
      String email,
      String website,
      String contactInfo,
      String city,
      String state,
      String zip,
      {String id,
      Map<String, BandMember> bandmates, List<String> files,String creatorName}) async {
    Band band = Band(
      dateStarted: dateStarted,
      email: email,
      contactInfo: contactInfo,
      legalName: blname,
      legalStructure: legalstructure,
      musicStyle: musicStyle,
      name: bname,
      website: website,
      city: city,
      state: state,
      zip: zip,
      files:files,
      bandmates: bandmates,
      creatorName:creatorName
    );
    band.userId = serverAPI.currentUserId;
    if (id != null) {
      band.id = id;
    }

    final res = await serverAPI.addBand(band);
    print("REs-> $res");
    if (res is bool) {
      (view as AddBandContract).addBandSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getBandDetails(String id) async {
    final res = await serverAPI.getBandDetails(id);
    if (res is Band) {
      (view as AddBandContract).getBandDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deleteBand(String id) async {
    serverAPI.deleteBand(id);
  }

  void getPlayingStyleList(String bandId) async {
    if (bandId != null) {
      final snapshot = await serverAPI.playingStyleDB
          .orderByChild('bandId')
          .equalTo(bandId)
          .once();
      Map mp = snapshot.value;
      if (mp == null) return null;
      List<UserPlayingStyle> acc = [];
      for (var d in mp.values) {
        acc.add(UserPlayingStyle.fromJSON(d));
      }
      (view as AddBandContract).onData(acc);
    } else {
      final snapshot = await serverAPI.playingStyleDB
          .orderByChild('user_id')
          .equalTo(serverAPI.currentUserId)
          .once();
      Map mp = snapshot.value;
      if (mp == null) return null;
      List<UserPlayingStyle> acc = [];
      for (var d in mp.values) {
        acc.add(UserPlayingStyle.fromJSON(d));
      }
      (view as AddBandContract).onData(acc);
    }
  }
  void getUserProfile() async {
    final res = await serverAPI.getSingleUserById(serverAPI.currentUserId);
    if (res is User) {
      (view as AddBandContract).onUserDetailsSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
