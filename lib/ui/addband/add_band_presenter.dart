import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class AddBandContract extends BaseContract {
  void addBandSuccess();
  void onUpdate();
  void getBandDetails(Band band);
}

class AddBandPresenter extends BasePresenter {
  AddBandPresenter(BaseContract view) : super(view);

  void addBand(int dateStarted, String musicStyle, String bname, String blname,
      String legalstructure, String email, String website,
      {String id}) async {
    Band band = Band(
      dateStarted: dateStarted,
      email: email,
      legalName: blname,
      legalStructure: legalstructure,
      musicStyle: musicStyle,
      name: bname,
      website: website,
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

  void addMemberToBand(String bandId, String userId) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      res.bandmates[userId] = 0;
      await serverAPI.addBand(res);
      (view as AddBandContract).onUpdate();
    }
  }
}
