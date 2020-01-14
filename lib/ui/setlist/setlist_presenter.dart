import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/setlist.dart';

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
            setList.bandId == bandId)
          acc.add(setList);
        else if (setList.user_id != null &&
            setList.user_id == serverAPI.currentUserId) {
          acc.add(setList);
        }
      }
      return acc;
    });
  }
}
