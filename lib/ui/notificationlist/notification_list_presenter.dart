import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notification_list_response.dart';

abstract class NotificationListContract extends BaseContract {
  void onNotificationSuccess(NotificationListResponse res);
}

class NotificationListPresenter extends BasePresenter {
  NotificationListPresenter(BaseContract view) : super(view);

  void getNotifications() async {
    final res = await serverAPI.getNotifications();
    if (res is NotificationListResponse) {
      (view as NotificationListContract).onNotificationSuccess(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
