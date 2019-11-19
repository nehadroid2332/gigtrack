import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';

abstract class DashboardContract extends BaseContract {
  void onData(List<UserPlayingStyle> acc);
}

class DashboardPresenter extends BasePresenter {
  DashboardPresenter(BaseContract view) : super(view);

  void logout() async {
    serverAPI.logout();
  }

  void getPlayingStyleList(String bandId) async {
    if (bandId != null && bandId.isNotEmpty) {
      final snapshot = await serverAPI.playingStyleDB
          .orderByChild('bandId')
          .equalTo(bandId)
          .once();
      Map mp = snapshot.value;
      if (mp == null) return null;
      List<UserPlayingStyle> acc = [];
      for (var d in mp.values) {
        acc.add(UserPlayingStyle.fromJSON(d));
      }
      (view as DashboardContract).onData(acc);
    } else {
      final snapshot = await serverAPI.playingStyleDB
          .orderByChild('user_id')
          .equalTo(serverAPI.currentUserId)
          .once();
      Map mp = snapshot.value;
      if (mp == null) return null;
      List<UserPlayingStyle> acc = [];
      for (var d in mp.values) {
        acc.add(UserPlayingStyle.fromJSON(d));
      }
      (view as DashboardContract).onData(acc);
    }
  }
}
