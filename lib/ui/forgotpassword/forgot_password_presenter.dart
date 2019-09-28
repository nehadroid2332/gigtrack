import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/forgot_password_response.dart';

abstract class ForgotPasswordContract extends BaseContract {
  void onSuccess();
}

class ForgotPasswordPresenter extends BasePresenter {
  ForgotPasswordPresenter(BaseContract view) : super(view);

  void forgotPassword(String email) async {
    final res = await serverAPI.forgotPassword(email);
    if (res==null) {
      (view as ForgotPasswordContract).onSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
