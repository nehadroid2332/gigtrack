import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';

abstract class BandListContract extends BaseContract {
  void onBandList(List<Band> bands);
}

class BandListPresenter extends BasePresenter {
  BandListPresenter(BaseContract view) : super(view);

  Stream<List<Band>> getBands() {
    return serverAPI.bandDB.onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<Band> acc = [];
      for (var d in mp.values) {
        Band band = Band.fromJSON(d);
        if (band.userId == serverAPI.currentUserId ||
            band.bandmates.keys
                .contains(serverAPI.currentUserEmail.replaceAll(".", ""))) {
          acc.add(band);
        }
      }
      return acc;
    });
  }
}
