import 'package:firebase_auth/firebase_auth.dart';
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

  String currentUserId;
  void getCurrentUser() async {
    FirebaseUser firebaseUser = await serverAPI.getCurrentUser();
    currentUserId = firebaseUser?.uid;
  }
}
