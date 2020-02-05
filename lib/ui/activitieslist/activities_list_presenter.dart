import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';

abstract class ActivitiesListContract extends BaseContract {
  void getBands(List<Band> acc);

  void bandDetails(Band band);
}

class ActivitiesListPresenter extends BasePresenter {
  ActivitiesListPresenter(BaseContract view) : super(view);

  Stream<List<Activites>> getList(String bandId, int type) {
    return serverAPI.activitiesDB.onValue.asyncMap((a) async {
      Map mp = a.snapshot.value;
      if (mp == null) return null;

      final res = await serverAPI.bandDB.once();
      Map mp1 = res.value;
      List<Band> bands = [];
      if (mp1 != null) {
        for (var d in mp1.values) {
          Band band = Band.fromJSON(d);
          if (band.userId == serverAPI.currentUserId ||
              band.bandmates.keys
                  .contains(serverAPI.currentUserEmail.replaceAll(".", ""))) {
            bands.add(band);
          }
        }
      }

      List<Activites> acc = [];
      for (var d in mp.values) {
        Activites activites = Activites.fromJSON(d);

        if (activites.bandId != null && activites.bandId.isNotEmpty) {
          Band band;
          for (var item in bands) {
            if (item.id == activites.bandId) {
              band = item;
            }
          }
          if (band != null) {
            activites.band = band;
          }
        }
        if (bandId.isEmpty) {
          if (activites.band != null) {
            if (activites.band.bandmates.keys
                .contains(serverAPI.currentUserEmail.replaceAll(".", "")) ||
                activites.band.userId == serverAPI.currentUserId) {
              acc.add(activites);
            }
          }
          if (activites.userId == serverAPI.currentUserId) {
            if (acc.contains(activites)) {
              continue;
            } else {
              acc.add(activites);
            }
          }
        } else {
          if (activites.band != null && bandId.isNotEmpty) {
            if ( // activites.band.bandmates.keys.contains(serverAPI.currentUserEmail.replaceAll(".", "")) &&
            activites.band.id == bandId) {
              acc.add(activites);
            }
          }
        }

        //        else {
        //          acc.add(activites);
        //        }
      }
      return acc;
    });
    // }
  }

  void getBands(String bandId) async {
    final res = await serverAPI.bandDB.once();
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
        if (band.id == bandId) {
          (view as ActivitiesListContract).bandDetails(band);
        }
      }
    }
    (view as ActivitiesListContract).getBands(acc);
  }
}