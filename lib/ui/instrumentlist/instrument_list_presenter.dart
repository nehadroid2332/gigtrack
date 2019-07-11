import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/instruments_list_response.dart';

abstract class InstrumentListContract extends BaseContract {
  void getInstruments(List<Instrument> list);
}

class InstrumentListPresenter extends BasePresenter {
  InstrumentListPresenter(BaseContract view) : super(view);

  void getInstruments() async {
    final res = await serverAPI.getInstruments();
    if (res is InstrumentListResponse) {
      (view as InstrumentListContract).getInstruments(res.data);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
