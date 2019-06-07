import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/add_band_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddBandContract extends BaseContract {
  void addBandSuccess();
}

class AddBandPresenter extends BasePresenter {
  AddBandPresenter(BaseContract view) : super(view);

  void addBand(
      String dateStarted,
      String musicStyle,
      String bname,
      String blname,
      String legalstructure,
      String bandRes,
      String email,
      String website) async {
    final res = await serverAPI.addBand(Band(
      dateStarted: dateStarted,
      email: email,
      legalName: blname,
      legalStructure: legalstructure,
      musicStyle: musicStyle,
      name: bname,
      responsbilities: bandRes,
      website: website,
    ));
    print("REs-> $res");
    if (res is AddBandResponse) {
      (view as AddBandContract).addBandSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
