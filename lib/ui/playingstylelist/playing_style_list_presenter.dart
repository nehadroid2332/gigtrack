import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';

abstract class PlayingStyleListContract extends BaseContract {
  void onData(List<UserPlayingStyle> acc);
}

class PlayingStyleListPresenter extends BasePresenter {
  PlayingStyleListPresenter(BaseContract view) : super(view);

  Stream<List<UserPlayingStyle>> getList(String bandId) {
    if (bandId != null)
      return serverAPI.playingStyleDB
          .orderByChild('bandId')
          .equalTo(bandId)
          .onValue
          .map((a) {
        Map mp = a.snapshot.value;
        if (mp == null) return null;
        List<UserPlayingStyle> acc = [];
        for (var d in mp.values) {
          acc.add(UserPlayingStyle.fromJSON(d));
        }
        (view as PlayingStyleListContract).onData(acc);
        return acc;
      });
    else
      return serverAPI.playingStyleDB
          .orderByChild('user_id')
          .equalTo(serverAPI.currentUserId)
          .onValue
          .map((a) {
        Map mp = a.snapshot.value;
        if (mp == null) return null;
        List<UserPlayingStyle> acc = [];
        for (var d in mp.values) {
          acc.add(UserPlayingStyle.fromJSON(d));
        }
        (view as PlayingStyleListContract).onData(acc);
        return acc;
      });
  }
}
