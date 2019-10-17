import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddMemberToBandContract extends BaseContract {
  void onSearchUser(List<Contacts> users);

  void onMemberAdd();
}

class AddMemberToBandPresenter extends BasePresenter {
  AddMemberToBandPresenter(BaseContract view) : super(view);

  void searchUser(String text) async {
    final res = await serverAPI.searchUser(text);
    if (res is List<Contacts>) {
      (view as AddMemberToBandContract).onSearchUser(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addMemberToBand(BandMember bandMember, String bandId) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      // if (bandMember.user_id == null) {
      //   User user = User(
      //     email: bandMember.email,
      //     firstName: bandMember.firstName,
      //     lastName: bandMember.lastName,
      //     password: "gigtrack123",
      //     phone: bandMember.mobileText,
      //   );
      //   final ress = await serverAPI.internalRegister(user);
      //   if (ress is User) {
      //     bandMember.user_id = ress.id;
      //   } else if (ress is ErrorResponse) {
      //     view.showMessage(ress.message);
      //     return;
      //   }
      // }
      res.bandmates[bandMember.email.replaceAll(".", "")] = bandMember;
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
