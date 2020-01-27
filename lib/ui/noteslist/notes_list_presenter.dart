import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/user.dart';

abstract class NotesListContract extends BaseContract {}

class NotesListPresenter extends BasePresenter {
  NotesListPresenter(BaseContract view) : super(view);

  Stream<List<NotesTodo>> getList(bool isLeader) {
    return serverAPI
        .notesDB
        // .orderByChild('user_id')
        // .equalTo(serverAPI.currentUserId)
        .onValue
        .asyncMap((a) async {
      Map mp = a.snapshot.value;
      if (mp == null) return null;

      final res = await serverAPI.bandDB.once();
      Map mp1 = res.value;
      List<Band> bands = [];
      if (mp1 != null) {
        for (var d in mp1.values) {
          Band band = Band.fromJSON(d);
          if (band.userId == serverAPI.currentUserId ||
              band.bandmates.keys
                  .contains(serverAPI.currentUserEmail.replaceAll(".", ""))) {
            bands.add(band);
          }
        }
      }

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
        } else {
          if (notesTodo.bandId != null) {
            for (var b in bands) {
              if (b.id == notesTodo.bandId) {
                notesTodo.band = b;
                break;
              }
            }
            if (notesTodo.status == NotesTodo.STATUS_APPROVED) {
              acc.add(notesTodo);
            } else if (isLeader) {
              acc.add(notesTodo);
            }
          }
        }
      }
      return acc;
    });
  }
}
