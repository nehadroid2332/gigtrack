import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';

abstract class BandListContract extends BaseContract {
  void onBandList(List<Band> bands);
}

class BandListPresenter extends BasePresenter {
  BandListPresenter(BaseContract view) : super(view);

  Stream<List<Band>> getBands({String filter}) {
    return serverAPI.bandDB.onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<Band> acc = [];
      for (var d in mp.values) {
        Band band = Band.fromJSON(d);
        if (band.userId == serverAPI.currentUserId) {
          acc.add(band);
        } else {
          for (var key in band.bandmates.keys) {
            if (key.toLowerCase() ==
                serverAPI.currentUserEmail.replaceAll(".", "").toLowerCase()) {
              acc.add(band);
            }
          }
        }
      }

      if (filter != null) {
        if (filter == "Newest") {
          acc.sort((a, b) {
            return a.created.compareTo(b.created);
          });
        } else if (filter == "Oldest") {
          acc.sort((a, b) {
            return b.created.compareTo(a.created);
          });
        } else if (filter == "My Band") {
          return acc.where((a) {
            return a.userId == serverAPI.currentUserId;
          }).toList();
        }
      }
      return acc;
    });
  }
}
