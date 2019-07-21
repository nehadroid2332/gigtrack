import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/playing_style_response.dart';

abstract class PlayingStyleListContract extends BaseContract {
  void onListSuccess(
    List<UserPlayingStyle> list,
    List<Instruments> iList,
    List<PlayingStyle> pList,
  );
}

class PlayingStyleListPresenter extends BasePresenter {
  PlayingStyleListPresenter(BaseContract view) : super(view);

  void playingStyleList() async {
    final res = await serverAPI.getPlayingStyleList();
    if (res is PlayingStyleResponse) {
      (view as PlayingStyleListContract)
          .onListSuccess(res.user_playing_styles, res.instruments, res.pstyles);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
