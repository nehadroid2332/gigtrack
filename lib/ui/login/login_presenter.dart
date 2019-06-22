import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/login_response.dart';

abstract class LoginContract extends BaseContract {
  void loginSuccess(String token, String userId);
}

class LoginPresenter extends BasePresenter {
  LoginPresenter(BaseContract view) : super(view);

  void loginUser(String email, String password) async {
    final res = await serverAPI.login(email, password);
    print("REs--> $res");
    if (res is LoginResponse) {
      (view as LoginContract).loginSuccess(res.token, res.user_id);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addLogin(String userId, String token) {
    serverAPI.setUpHeaderAfterLogin(userId, token);
  }
}
