import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band_comm.dart';

class BandCommListPresenter extends BasePresenter {
  BandCommListPresenter(BaseContract view) : super(view);

  Stream<List<BandCommunication>> getList(String bandId) {
    return serverAPI.bandCommDB.onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<BandCommunication> acc = [];
      for (var d in mp.values) {
        final bullets = BandCommunication.fromJSON(d);
        if (bandId != null && bandId == bullets.bandId) acc.add(bullets);
      }
      return acc;
    });
  }
}
