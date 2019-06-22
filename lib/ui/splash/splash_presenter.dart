import 'package:gigtrack/base/base_presenter.dart';

abstract class SplashContract extends BaseContract {
  void loginSucess(bool isLoginSuccess);
}

class SplashPresenter extends BasePresenter {
  SplashPresenter(BaseContract view) : super(view);

  void movetoLogin() async {
    await Future.delayed(Duration(seconds: 2));
    (view as SplashContract).loginSucess(true);
  }

  void addLogin(String userId, String token) {
    serverAPI.setUpHeaderAfterLogin(userId, token);
  }
}
