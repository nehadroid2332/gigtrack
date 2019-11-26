import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/setlist.dart';

class SetListPresenter extends BasePresenter {
  SetListPresenter(BaseContract view) : super(view);

  Stream<List<SetList>> getData(String id) {
    return serverAPI.setListDB
        .orderByChild('user_id')
        .equalTo(id)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<SetList> acc = [];
      for (var d in mp.values) {
        acc.add(SetList.fromJSON(d));
      }
      return acc;
    });
  }
}
