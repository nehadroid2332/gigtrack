import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/add_playing_style_response.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/playing_style_response.dart';

abstract class AddPlayingStyleContract extends BaseContract {
  void onListSuccess(
    List<UserPlayingStyle> list,
    List<Instruments> iList,
    List<PlayingStyle> pList,
  );

  void onAddSuccess();
}

class AddPlayingStylePresenter extends BasePresenter {
  AddPlayingStylePresenter(BaseContract view) : super(view);

  void getList() async {
    final res = await serverAPI.getPlayingStyleList();
    if (res is PlayingStyleResponse) {
      (view as AddPlayingStyleContract)
          .onListSuccess(res.user_playing_styles, res.instruments, res.pstyles);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addPlayingStyle(String userId, String psId, String inId) async {
    final res = await serverAPI.addUserPlayingStyle(userId, "0", psId, inId);
    if (res is AddPlayingStyleResponse) {
      (view as AddPlayingStyleContract).onAddSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
