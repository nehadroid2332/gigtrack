import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';

abstract class AddPlayingStyleContract extends BaseContract {
  void onAddSuccess();
  void onUpdateSuccess();
  void onDetailsSuccess(UserPlayingStyle userPlayingStyle);

  void onDelete();
}

class AddPlayingStylePresenter extends BasePresenter {
  AddPlayingStylePresenter(BaseContract view) : super(view);

  void addPlayingStyle(UserPlayingStyle userPlayingStyle) async {
    userPlayingStyle.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addUserPlayingStyle(userPlayingStyle);
    if (res is bool) {
      if (res)
        (view as AddPlayingStyleContract).onUpdateSuccess();
      else
        (view as AddPlayingStyleContract).onAddSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getPlayingStyleDetails(String id) async {
    final res = await serverAPI.getPlayingStyleDetails(id);
    if (res is UserPlayingStyle) {
      (view as AddPlayingStyleContract).onDetailsSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deletePlayingStyle(String id) async {
    await serverAPI.deletePlayingStyle(id);
    (view as AddPlayingStyleContract).onDelete();
  }
}
