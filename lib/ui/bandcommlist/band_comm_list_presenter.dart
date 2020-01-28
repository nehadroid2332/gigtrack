import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band_comm.dart';

class BandCommListPresenter extends BasePresenter {
  BandCommListPresenter(BaseContract view) : super(view);

  Stream<List<BandCommunication>> getList() {
    return serverAPI.bandCommDB.onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<BandCommunication> acc = [];
      for (var d in mp.values) {
        final bullets = BandCommunication.fromJSON(d);
        acc.add(bullets);
      }
      return acc;
    });
  }
}
