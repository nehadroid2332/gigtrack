import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddBandContract extends BaseContract {
  void addBandSuccess();
  void onUpdate();
  void getBandDetails(Band band);
}

class AddBandPresenter extends BasePresenter {
  AddBandPresenter(BaseContract view) : super(view);

  void addBand(
      int dateStarted,
      String musicStyle,
      String bname,
      String blname,
      String legalstructure,
      String email,
      String website,
      String contactInfo,
      String city,
      String state,
      String zip,
      {String id,
      Map<String, BandMember> bandmates}) async {
    Band band = Band(
      dateStarted: dateStarted,
      email: email,
      contactInfo: contactInfo,
      legalName: blname,
      legalStructure: legalstructure,
      musicStyle: musicStyle,
      name: bname,
      website: website,
      city: city,
      state: state,
      zip: zip,
      bandmates: bandmates,
    );
    band.userId = serverAPI.currentUserId;
    if (id != null) {
      band.id = id;
    }

    final res = await serverAPI.addBand(band);
    print("REs-> $res");
    if (res is bool) {
      (view as AddBandContract).addBandSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getBandDetails(String id) async {
    final res = await serverAPI.getBandDetails(id);
    if (res is Band) {
      (view as AddBandContract).getBandDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deleteBand(String id) async {
    serverAPI.deleteBand(id);
  }
}
