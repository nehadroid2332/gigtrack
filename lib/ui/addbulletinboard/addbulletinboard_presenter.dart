import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notifications.dart';
import 'package:gigtrack/server/models/user.dart';

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
      } else {
        (view as AddBulletInBoardContract).onSuccess();
      }
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

  void updateStatus(String id, int status, int visibleDays) async {
    final res = await serverAPI.getBulletInBoardDetails(id);
    if (res is BulletInBoard) {
      res.visibleDays = visibleDays;
      res.created = DateTime.now().millisecondsSinceEpoch;
      res.status = status;
      await serverAPI.addBulletInBoard(res);
      if (status == BulletInBoard.STATUS_APPROVED) sendNotification(res.id);
      (view as AddBulletInBoardContract).onUpdate();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void sendNotification(String id) async {
    final res = await serverAPI.userDB.once();
    Map mp1 = res.value;
    if (mp1 != null) {
      for (var d in mp1.values) {
        User user = User.fromJSON(d);
        final not = await serverAPI.addNotification(Notification(
          created: DateTime.now().millisecondsSinceEpoch,
          notiId: id,
          text: "A new Bullet-In Board created",
          type: Notification.TYPE_BULLETIN_BOARD,
          userId: user.id,
        ));
        if (not != null && not is Notification) {
          serverAPI.sendPushNotification(not);
        }
      }
    }
  }
}
