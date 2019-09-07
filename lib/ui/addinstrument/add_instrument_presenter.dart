import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/add_instrument_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/instruments_list_response.dart';

abstract class AddInstrumentContract extends BaseContract {
  void addInstrumentSuccess(AddInstrumentResponse res);
  void onBandList(List<Band> bands);
  void getInstrumentDetails(Instrument instrument);
}

class AddInstrumentPresenter extends BasePresenter {
  AddInstrumentPresenter(BaseContract view) : super(view);

  void addInstrument(Instrument instrument) async {
    final res = await serverAPI.addInstrument(instrument);
    if (res is AddInstrumentResponse) {
      (view as AddInstrumentContract).addInstrumentSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getBands() async {
    // final res = await serverAPI.getBands();
    // if (res is BandListResponse) {
    //   (view as AddInstrumentContract).onBandList(res.bandList);
    // } else if (res is ErrorResponse) {
    //   view.showMessage(res.message);
    // }
  }

  void getInstrumentDetails(String id) async {
    final res = await serverAPI.getInstrumentDetails(id);
    if (res is InstrumentListResponse) {
      (view as AddInstrumentContract).getInstrumentDetails(res.data[0]);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
