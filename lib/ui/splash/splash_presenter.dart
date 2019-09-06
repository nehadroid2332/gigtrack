import 'package:firebase_auth/firebase_auth.dart';
import 'package:gigtrack/base/base_presenter.dart';

abstract class SplashContract extends BaseContract {
  void loginSuccess(bool isLoginSuccess);
}

class SplashPresenter extends BasePresenter {
  SplashPresenter(BaseContract view) : super(view);

  void movetoLogin() async {
    await Future.delayed(Duration(seconds: 2));
    FirebaseUser user = await serverAPI.getCurrentUser();
    (view as SplashContract).loginSuccess(user != null);
  }
}
