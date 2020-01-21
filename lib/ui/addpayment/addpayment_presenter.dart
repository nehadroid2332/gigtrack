import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/payment.dart';

abstract class AddPaymentContract extends BaseContract {
  void onSuccess();
  void onUpdate();
  void onSubSuccess();
  void getBulletInBoardDetails(Payment note);

  void onStatusUpdate();
}

class AddPaymentPresenter extends BasePresenter {
  AddPaymentPresenter(BaseContract view) : super(view);

  void addPayment(Payment bulletinboard) async {
    bulletinboard.user_id = serverAPI.currentUserId;
    final res = await serverAPI.addPayment(bulletinboard);
    if (res is bool) {
      if (res) {
        (view as AddPaymentContract).onUpdate();
      } else {
        (view as AddPaymentContract).onSuccess();
      }
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void getPaymentDetails(String id) async {
    final res = await serverAPI.getPaymentDetails(id);
    if (res is Payment) {
      (view as AddPaymentContract).getBulletInBoardDetails(res);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void deletePayment(String id) {
    serverAPI.deleteBulletInboard(id);
  }
}
