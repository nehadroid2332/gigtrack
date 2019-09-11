import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';

abstract class PlayingStyleListContract extends BaseContract {}

class PlayingStyleListPresenter extends BasePresenter {
  PlayingStyleListPresenter(BaseContract view) : super(view);

  Stream<List<UserPlayingStyle>> getList() {
    return serverAPI.playingStyleDB
        .orderByChild('user_id')
        .equalTo(serverAPI.currentUserId)
        .onValue
        .map((a) {
      Map mp = a.snapshot.value;
      List<UserPlayingStyle> acc = [];
      for (var d in mp.values) {
        acc.add(UserPlayingStyle.fromJSON(d));
      }
      return acc;
    });
  }
}
