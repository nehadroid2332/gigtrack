import 'package:gigtrack/server/server_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseContract {
  void showMessage(String message);
  SharedPreferences get sharedPreferences;
}

abstract class BasePresenter {
  final BaseContract view;
  ServerAPI serverAPI;
  BasePresenter(this.view) {
    serverAPI = ServerAPI();
  }
}
