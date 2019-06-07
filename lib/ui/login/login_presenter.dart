import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/login_response.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

abstract class LoginContract extends BaseContract {
  void loginSuccess();
}

class LoginPresenter extends BasePresenter {
  LoginPresenter(BaseContract view) : super(view);

  void loginUser(String email, String password) async {
    final res = await serverAPI.login(email, password);
    print("REs--> $res");
    if (res is LoginResponse) {
      view.sharedPreferences
          .setString(SharedPrefsKeys.TOKEN.toString(), res.token);
      view.sharedPreferences
          .setString(SharedPrefsKeys.USERID.toString(), res.user_id);
      (view as LoginContract).loginSuccess();
    } else if (res is ErrorResponse) {
      view.showMessage(res.message);
    }
  }
}