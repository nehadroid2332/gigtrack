import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';

abstract class BulletInBoardListContract extends BaseContract {}

class BulletInBoardListPresenter extends BasePresenter {
  BulletInBoardListPresenter(BaseContract view) : super(view);

  Stream<List<BulletInBoard>> getList() {
    return serverAPI
        .bulletinDB
        // .orderByChild('user_id')
        // .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<BulletInBoard> acc = [];
      for (var d in mp.values) {
        final bullets = BulletInBoard.fromJSON(d);
        if (bullets.status == BulletInBoard.STATUS_APPROVED)
          acc.add(bullets);
        else if (serverAPI.currentUserId == "f7oNvNfTqPTuLQAVq6ZaeqllEBx1" &&
            (bullets.status == null ||
                bullets.status == BulletInBoard.STATUS_PENDING)) {
          acc.add(bullets);
        }
      }
      return acc;
    });
  }
}
