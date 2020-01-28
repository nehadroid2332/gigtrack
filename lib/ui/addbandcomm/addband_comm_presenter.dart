import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band_comm.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/payment.dart';

abstract class AddBandCommContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onSubSuccess();
  void getBandCommDetails(BandCommunication note);
  void onStatusUpdate();
}

class AddBandCommPresenter extends BasePresenter {
  AddBandCommPresenter(BaseContract view) : super(view);

  void addBandComm(BandCommunication bandComm) async {
    bandComm.userId = serverAPI.currentUserId;
    final res = await serverAPI.addBandComm(bandComm);
    if (res is bool) {
      if (res) {
        (view as AddBandCommContract).onUpdate();
      } else {
        (view as AddBandCommContract).onSuccess();
      }
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getBandCommDetails(String id) async {
    final res = await serverAPI.getBandCommDetails(id);
    if (res is BandCommunication) {
      (view as AddBandCommContract).getBandCommDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deleteBandComm(String id) {
    serverAPI.deleteBandComm(id);
  }
}
