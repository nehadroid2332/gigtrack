import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
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
          final note = NotesTodo.fromJSON(d);
          acc.add(note);
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
          final notesTodo = NotesTodo.fromJSON(d);
          if (notesTodo.bandId != null && notesTodo.bandId.isNotEmpty) {
            final res = await serverAPI.getBandDetails(notesTodo.bandId);
            if (res != null && res is Band) {
              notesTodo.band = res;
            }
          }
          if (notesTodo.user_id == serverAPI.currentUserId) {
            acc.add(notesTodo);
          } else if (notesTodo.user_id != null) {
            final res = await serverAPI.getSingleUserById(notesTodo.user_id);
            if (res is User && (res.isUnder18Age ?? false)) {
              if (res.guardianEmail == serverAPI.currentUserEmail) {
                acc.add(notesTodo);
              }
            }
          }
        }
        return acc;
      });
  }
}
