import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band_member_add_response.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/search_user_response.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class AddMemberToBandContract extends BaseContract {
  void onSearchUser(List<User> users);

  void onMemberAdd();
}

class AddMemberToBandPresenter extends BasePresenter {
  AddMemberToBandPresenter(BaseContract view) : super(view);

  void searchUser(String text) async {
    final res = await serverAPI.searchUser(text);
    if (res is SearchUserResponse) {
      (view as AddMemberToBandContract).onSearchUser(res.users);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addMemberToBand(String bandId, String userId) async {
    final res = await serverAPI.addBandMember(bandId, userId);
    if (res is BandMemberAddResponse) {
      (view as AddMemberToBandContract).onMemberAdd();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
