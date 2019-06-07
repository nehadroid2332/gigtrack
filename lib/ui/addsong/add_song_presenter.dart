import 'package:gigtrack/base/base_presenter.dart';

abstract class AddSongContract extends BaseContract {
  void onSongSuccess();
}

class AddSongPresenter extends BasePresenter {
  AddSongPresenter(BaseContract view) : super(view);

  void addSong() async {
    await Future.delayed(Duration(seconds: 2));
    (view as AddSongContract).onSongSuccess();
  }
}
