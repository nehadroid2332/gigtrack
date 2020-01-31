import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/setlist.dart';

abstract class SetListContract extends BaseContract {
  void onBandDetails(Band res);
}

class SetListPresenter extends BasePresenter {
  SetListPresenter(BaseContract view) : super(view);

  Stream<List<SetList>> getData(String bandId) {
    return serverAPI.setListDB.onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<SetList> acc = [];
      for (var d in mp.values) {
        SetList setList = SetList.fromJSON(d);
        if (bandId != null &&
            setList.bandId != null &&
            setList.bandId == bandId &&
            setList.user_id != null
            //setList.user_id == serverAPI.currentUserId
             )
          acc.add(setList);
        else if (setList.user_id != null &&
            setList.user_id == serverAPI.currentUserId&& bandId.isEmpty) {
          acc.add(setList);
        }
      }
      return acc;
    });
  }

  void getBand(String bandId) async {
    final res = await serverAPI.getBandDetails(bandId);
    if (res is Band) {
      (view as SetListContract).onBandDetails(res);
    }
  }
}
