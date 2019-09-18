import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/notestodo.dart';

abstract class NotesListContract extends BaseContract {}

class NotesListPresenter extends BasePresenter {
  NotesListPresenter(BaseContract view) : super(view);

  Stream<List<NotesTodo>> getList() {
    return serverAPI.notesDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<NotesTodo> acc = [];
      for (var d in mp.values) {
        acc.add(NotesTodo.fromJSON(d));
      }
      return acc;
    });
  }
}
