import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/instrument.dart';

abstract class InstrumentListContract extends BaseContract {}

class InstrumentListPresenter extends BasePresenter {
  InstrumentListPresenter(BaseContract view) : super(view);

  Stream<List<Instrument>> getList() {
    return serverAPI.equipmentsDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      List<Instrument> acc = [];
      for (var d in mp.values) {
        acc.add(Instrument.fromJSON(d));
      }
      return acc;
    });
  }
}
