import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class AddMemberToBandContract extends BaseContract {
  void onSearchUser(List<Contacts> users);
  void bandMemberDetails(BandMember bandMember, String primaryContactEmail);
  void onMemberAdd();
}

class AddMemberToBandPresenter extends BasePresenter {
  String primaryContactEmail;

  AddMemberToBandPresenter(BaseContract view) : super(view);

  void searchUser(String text) async {
    final res = await serverAPI.searchUser(text);
    if (res is List<Contacts>) {
      (view as AddMemberToBandContract).onSearchUser(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getBandMemberDetails(String bandId, {String id}) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      for (var key in res.bandmates.keys) {
        BandMember bandMember = res.bandmates[key];
        if (bandMember.email == id) {
          primaryContactEmail = res.primaryContactEmail;
          (view as AddMemberToBandContract).bandMemberDetails(bandMember,primaryContactEmail);
          return;
        }
      }
      view.showMessage("No Data");
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addMemberToBand(
      BandMember bandMember, String bandId, bool isPrimaryContact) async {
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
      final resw = await serverAPI.searchUserByEmail(bandMember.email);
      if (resw is User) {
        bandMember.user_id = resw.id;
      }
      res.bandmates[bandMember.email.replaceAll(".", "")] = bandMember;
      if (isPrimaryContact) res.primaryContactEmail = bandMember.email;
      final res2 = await serverAPI.addBand(res);
      if (res2 is bool) {
        final resss = await serverAPI.getSingleUserById(res.userId);
        if (resss is User) {
          // final resM = await serverAPI.sendEmail(res.name,
          //     resss.firstName + " " + resss.lastName, bandMember.email);
          // if (resM is String) {
          //   print("Email sent");
          // } else if (resM is ErrorResponse) {
          //   view.showMessage(resM.message);
          // }
        }
        // for (var mem in res.bandmates.keys) {
        //   BandMember bandMember = res.bandmates[mem];
        //   await serverAPI.addNotification(Notification(
        //     bandId: res.id,
        //     created: DateTime.now().millisecondsSinceEpoch,
        //     status: false,
        //     text: "A new member has been added in the band",
        //     type: 6,
        //     userId: bandMember.user_id
        //   ));
        // }
        (view as AddMemberToBandContract).onMemberAdd();
      } else if (res2 is ErrorResponse) {
        view.showMessage(res2.message);
      }
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
