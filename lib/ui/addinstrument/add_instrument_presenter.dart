import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user_instrument.dart';

abstract class AddInstrumentContract extends BaseContract {
  void addInstrumentSuccess();
  void onUpdate();
  void onBandList(List<Band> bands);
  void getInstrumentDetails(UserInstrument instrument);
}

class AddInstrumentPresenter extends BasePresenter {
  AddInstrumentPresenter(BaseContract view) : super(view);

  void addInstrument(UserInstrument instrument) async {
    instrument.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addInstrument(instrument);
    if (res is bool) {
      if (res) {
        (view as AddInstrumentContract).onUpdate();
      } else
        (view as AddInstrumentContract).addInstrumentSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  Stream<List<Band>> getBands() {
    return serverAPI.bandDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      List<Band> acc = [];
      for (var d in mp.values) {
        acc.add(Band.fromJSON(d));
      }
      return acc;
    });
  }

  void getInstrumentDetails(String id) async {
    final res = await serverAPI.getInstrumentDetails(id);
    if (res is UserInstrument) {
      (view as AddInstrumentContract).getInstrumentDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void instrumentDelete(String id) {
    serverAPI.deleteInstrument(id);
  }

  void addSubInstrumentNote(List<SubInstrumentNotes> subInstruments, String id) async{
    final res = await serverAPI.getInstrumentDetails(id);
    if (res is UserInstrument) {
      res.subNotes = subInstruments;
      await serverAPI.addInstrument(res);
      (view as AddInstrumentContract).getInstrumentDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
