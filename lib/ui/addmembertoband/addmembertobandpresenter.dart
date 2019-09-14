import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class AddMemberToBandContract extends BaseContract {
  void onSearchUser(List<User> users);

  void onMemberAdd();
}

class AddMemberToBandPresenter extends BasePresenter {
  AddMemberToBandPresenter(BaseContract view) : super(view);

  void searchUser(String text) async {
    final res = await serverAPI.searchUser(text);
    if (res is List<User>) {
      (view as AddMemberToBandContract).onSearchUser(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addMemberToBand(BandMember bandMember, String bandId) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      res.bandmates[bandMember.user_id] = bandMember;
      final res2 = await serverAPI.addBand(res);
      if (res2 is bool) {
        (view as AddMemberToBandContract).onMemberAdd();
      } else if (res2 is ErrorResponse) {
        view.showMessage(res2.message);
      }
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
