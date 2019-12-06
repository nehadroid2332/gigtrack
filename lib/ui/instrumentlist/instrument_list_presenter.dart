import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/user_instrument.dart';

abstract class InstrumentListContract extends BaseContract {}

class InstrumentListPresenter extends BasePresenter {
  InstrumentListPresenter(BaseContract view) : super(view);

  Stream<List<UserInstrument>> getList(String bandId) {
    if (bandId != null && bandId.isNotEmpty)
      return serverAPI.equipmentsDB
          .orderByChild('bandId')
          .equalTo(bandId)
          .onValue
          .map((a) {
        Map mp = a.snapshot.value;
        if (mp == null) return null;
        List<UserInstrument> acc = [];
        for (var d in mp.values) {
          acc.add(UserInstrument.fromJSON(d));
        }
        acc.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        return acc;
      });
    else
      return serverAPI.equipmentsDB
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
        if (contact.user_id == serverAPI.currentUserId) {
          acc.add(contact);
        }
         // acc.add(UserInstrument.fromJSON(d));
        }
        acc.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        return acc;
      });
  }
}
