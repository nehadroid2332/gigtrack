import 'package:firebase_auth/firebase_auth.dart';
import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/login_response.dart';

abstract class LoginContract extends BaseContract {
  void loginSuccess(String userId);
}

class LoginPresenter extends BasePresenter {
  LoginPresenter(BaseContract view) : super(view);

  void loginUser(String email, String password) async {
    final res = await serverAPI.login(email, password);
    print("REs--> $res");
    if (res is FirebaseUser) {
      (view as LoginContract).loginSuccess(res.uid);
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }

  void addLogin(String userId, String token) {
    serverAPI.setUpHeaderAfterLogin(userId, token);
  }
}
