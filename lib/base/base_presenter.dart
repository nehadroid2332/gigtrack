import 'package:gigtrack/server/server_api.dart';

abstract class BaseContract {
  void showMessage(String message);
}

abstract class BasePresenter {
  final BaseContract view;
  ServerAPI serverAPI;
  BasePresenter(this.view) {
    serverAPI = ServerAPI();
  }

}
