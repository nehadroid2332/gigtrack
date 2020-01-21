import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/payment.dart';

class PaymentListPresenter extends BasePresenter {
  PaymentListPresenter(BaseContract view) : super(view);

  Stream<List<Payment>> getList() {
    return serverAPI.paymentDB.onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<Payment> acc = [];
      for (var d in mp.values) {
        final bullets = Payment.fromJSON(d);
        acc.add(bullets);
      }
      return acc;
    });
  }
}
