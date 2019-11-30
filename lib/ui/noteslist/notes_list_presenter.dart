import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class NotesListContract extends BaseContract {}

class NotesListPresenter extends BasePresenter {
  NotesListPresenter(BaseContract view) : super(view);

  Stream<List<NotesTodo>> getList(String bandId) {
    if (bandId != null && bandId.isNotEmpty)
      return serverAPI.notesDB
          .orderByChild('bandId')
          .equalTo(bandId)
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
    else
      return serverAPI
          .notesDB
          // .orderByChild('user_id')
          // .equalTo(serverAPI.currentUserId)
          .onValue
          .asyncMap((a) async {
        Map mp = a.snapshot.value;
        if (mp == null) return null;
        List<NotesTodo> acc = [];
        for (var d in mp.values) {
          final contact = NotesTodo.fromJSON(d);
          if (contact.user_id == serverAPI.currentUserId) {
            acc.add(contact);
          } else if (contact.user_id != null) {
            final res = await serverAPI.getSingleUserById(contact.user_id);
            if (res is User && (res.isUnder18Age ?? false)) {
              if (res.guardianEmail == serverAPI.currentUserEmail) {
                acc.add(contact);
              }
            }
          }
        }
        return acc;
      });
  }
}
