import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/user_instrument.dart';

abstract class NotificationListContract extends BaseContract {}

class NotificationListPresenter extends BasePresenter {
  NotificationListPresenter(BaseContract view) : super(view);

  Stream<List<Activites>> getAList() {
    return serverAPI.activitiesDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;

      List<Activites> acc = [];
      for (var d in mp.values) {
        acc.add(Activites.fromJSON(d));
      }
      return acc;
    });
  }

  Stream<List<UserInstrument>> getEList() {
    return serverAPI.equipmentsDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;

      List<UserInstrument> acc = [];
      for (var d in mp.values) {
        acc.add(UserInstrument.fromJSON(d));
      }
      return acc;
    });
  }

  Stream<List<NotesTodo>> getNList() {
    return serverAPI.notesDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;

      List<NotesTodo> acc = [];
      for (var d in mp.values) {
        acc.add(NotesTodo.fromJSON(d));
      }
      return acc;
    });
  }
}
