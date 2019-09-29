import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/server/models/error_response.dart';


abstract class AddBulletInBoardContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onSubSuccess();
  void getBulletInBoardDetails(BulletInBoard note);
}

class AddBuiltInBoardPresenter extends BasePresenter {
  AddBuiltInBoardPresenter(BaseContract view) : super(view);

  void addBulletIn(BulletInBoard bulletinboard) async {
    bulletinboard.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addBulletInBoard(bulletinboard);
    if (res is bool) {
      if (res) {
        (view as AddBulletInBoardContract).onUpdate();
      } else
        (view as AddBulletInBoardContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getBulletInBoardDetails(String id) async {
    final res = await serverAPI.getBulletInBoardDetails(id);
    if (res is BulletInBoard) {
      (view as AddBulletInBoardContract).getBulletInBoardDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void bulletinboardDelete(String id) {
    serverAPI.deleteBulletInboard(id);
  }
}
