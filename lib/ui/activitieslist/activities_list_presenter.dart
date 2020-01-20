import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';

abstract class ActivitiesListContract extends BaseContract {
  void getBands(List<Band> acc);
}

class ActivitiesListPresenter extends BasePresenter {
  ActivitiesListPresenter(BaseContract view) : super(view);

  Stream<List<Activites>> getList(String bandId, int type) {
    // if (bandId != null && bandId.isNotEmpty) {
    //   return serverAPI.activitiesDB
    //       .orderByChild('bandId')
    //       .equalTo(bandId)
    //       .onValue
    //       .asyncMap((a) async {
    //     Map mp = a.snapshot.value;
    //     if (mp == null) return null;
    //     List<Activites> acc = [];
    //     for (var d in mp.values) {
    //       Activites activites = Activites.fromJSON(d);
    //       final band = await serverAPI.getBandDetails(activites.bandId);
    //       activites.band = band;
    //       if (type != null) {
    //         if (type == activites.type) {
    //           acc.add(activites);
    //         }
    //       } else {
    //         acc.add(activites);
    //       }
    //     }

    //     return acc;
    //   });
    // } else {
    return serverAPI
        .activitiesDB
        // .orderByChild('user_id')
        // .equalTo(serverAPI.currentUserId)
        .onValue
        .asyncMap((a) async {
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
        if (activites.userId == serverAPI.currentUserId) acc.add(activites);
      }
      return acc;
    });
    // }
  }

  void getBands() async {
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
      }
    }
    (view as ActivitiesListContract).getBands(acc);
  }
}
