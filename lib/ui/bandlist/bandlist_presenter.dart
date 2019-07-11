import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_list_response.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class BandListContract extends BaseContract {
  void onBandList(List<Band> bands);
}

class BandListPresenter extends BasePresenter {
  BandListPresenter(BaseContract view) : super(view);

  void getBands() async {
    final res = await serverAPI.getBands();
    if (res is BandListResponse) {
      (view as BandListContract).onBandList(res.bandList);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
