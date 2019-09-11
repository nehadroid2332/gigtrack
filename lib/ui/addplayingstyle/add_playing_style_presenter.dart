import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';

abstract class AddPlayingStyleContract extends BaseContract {
  void onListSuccess(
    List<String> iList,
    List<String> pList,
  );

  void onAddSuccess();
  void onUpdateSuccess();
}

class AddPlayingStylePresenter extends BasePresenter {
  AddPlayingStylePresenter(BaseContract view) : super(view);

  void getList() async {
    List<String> instruments = [];
    instruments.add("Guitar-Lead");
    instruments.add("Guitar-Rhythm");
    instruments.add("Bass");
    instruments.add("Drums");
    instruments.add("Keys");
    instruments.add("Piano");
    instruments.add("Harmonica");
    instruments.add("Vocals-Lead");
    instruments.add("Vocals-Harmony");

    List<String> playingStyle = [];
    playingStyle.add("Bluegrass");
    playingStyle.add("Blues");
    playingStyle.add("Celtic");
    playingStyle.add("Classic Rock");
    playingStyle.add("Country");
    playingStyle.add("Country Rock");
    playingStyle.add("Easy Listening");
    playingStyle.add("Gospel");
    playingStyle.add("Jazz");
    playingStyle.add("Metal");
    playingStyle.add("Punjabi");
    playingStyle.add("Punk");
    playingStyle.add("Raggae");
    (view as AddPlayingStyleContract).onListSuccess(instruments, playingStyle);
  }

  void addPlayingStyle(String psId, String inId) async {
    final res = await serverAPI.addUserPlayingStyle(UserPlayingStyle(
      user_id: serverAPI.currentUserId,
      playing_styles: psId,
      instruments: inId,
    ));
    if (res is bool) {
      if (res)
        (view as AddPlayingStyleContract).onUpdateSuccess();
      else
        (view as AddPlayingStyleContract).onAddSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
