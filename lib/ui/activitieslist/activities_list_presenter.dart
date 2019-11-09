import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';

abstract class ActivitiesListContract extends BaseContract {
  void getBands(List<Band> acc);
}

class ActivitiesListPresenter extends BasePresenter {
  ActivitiesListPresenter(BaseContract view) : super(view);

  Stream<List<Activites>> getList(String bandId) {
    if (bandId != null && bandId.isNotEmpty) {
      return serverAPI.activitiesDB
          .orderByChild('bandId')
          .equalTo(bandId)
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
    } else {
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
  }

  void getBands() async {
    final res = await serverAPI.bandDB.orderByChild("key").once();
    Map mp = res.value;
    List<Band> acc = [];
    if (mp != null) {
      for (var d in mp.values) {
        Band band = Band.fromJSON(d);
        if (band.userId == serverAPI.currentUserId ||
            band.bandmates.keys
                .contains(serverAPI.currentUserEmail.replaceAll(".", ""))) {
          acc.add(band);
        }
      }
    }
    (view as ActivitiesListContract).getBands(acc);
  }
}
