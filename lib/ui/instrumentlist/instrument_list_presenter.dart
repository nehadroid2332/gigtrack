import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user_instrument.dart';

abstract class InstrumentListContract extends BaseContract {
  void onBandDetails(Band res);
}

class InstrumentListPresenter extends BasePresenter {
  InstrumentListPresenter(BaseContract view) : super(view);

  Stream<List<UserInstrument>> getList(String bandId) {
    return serverAPI
        .equipmentsDB
        //  .orderByChild('user_id')
        //  .equalTo(serverAPI.currentUserId)
        .onValue
        .asyncMap((a) async {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<UserInstrument> acc = [];
      for (var d in mp.values) {
        final contact = UserInstrument.fromJSON(d);
        if (contact.bandId != null && contact.bandId.isNotEmpty) {
          final res = await serverAPI.getBandDetails(contact.bandId);
          if (res != null && res is Band) {
            contact.band = res;
          }
        }
        if (bandId.isEmpty) {
          if (contact.band != null) {
            if (contact.band.bandmates.keys.contains(serverAPI.currentUserEmail.replaceAll(".", "")) || contact.band.userId == serverAPI.currentUserId) {
              acc.add(contact);
            }
          }
          if (contact.user_id == serverAPI.currentUserId) {
            if (acc.contains(contact)) {
              continue;
            } else {
              acc.add(contact);
            }
          }
        } else {
          if (contact.band != null && bandId.isNotEmpty) {
            if ( // activites.band.bandmates.keys.contains(serverAPI.currentUserEmail.replaceAll(".", "")) &&
                contact.band.id == bandId) {
              acc.add(contact);
            }
          }
        }
        // acc.add(UserInstrument.fromJSON(d));
      }
      acc.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      return acc;
    });
  }

  void getBand(String bandId) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      (view as InstrumentListContract).onBandDetails(res);
    }
  }
}
