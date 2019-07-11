import 'package:gigtrack/base/base_presenter.dart';

abstract class SplashContract extends BaseContract {
  void loginSuccess(bool isLoginSuccess);
}

class SplashPresenter extends BasePresenter {
  SplashPresenter(BaseContract view) : super(view);

  void movetoLogin() async {
    await Future.delayed(Duration(seconds: 2));
    (view as SplashContract).loginSuccess(true);
  }

  void addLogin(String userId, String token) {
    serverAPI.setUpHeaderAfterLogin(userId, token);
  }
}
