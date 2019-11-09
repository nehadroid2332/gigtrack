import 'package:firebase_auth/firebase_auth.dart';
import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';

abstract class LoginContract extends BaseContract {
  void loginSuccess(String userId);
}

class LoginPresenter extends BasePresenter {
  LoginPresenter(BaseContract view) : super(view);

  void loginUser(String email, String password) async {
    final res = await serverAPI.login(email, password);
    if (res is FirebaseUser) {
      serverAPI.firebaseMessaging.subscribeToTopic(res.uid);
      (view as LoginContract).loginSuccess(res.uid);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}
