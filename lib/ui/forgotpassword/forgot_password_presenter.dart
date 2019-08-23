import 'package:gigtrack/base/base_presenter.dart';

abstract class ForgotPasswordContract extends BaseContract {
  void onSuccess();
}

class ForgotPasswordPresenter extends BasePresenter {
  ForgotPasswordPresenter(BaseContract view) : super(view);

  void forgotPassword(String email) async {
    final res = await serverAPI.forgotPassword(email);
    
  }
}
