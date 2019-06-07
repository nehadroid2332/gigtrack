import 'package:gigtrack/base/base_model.dart';

class LoginResponse extends BaseModel {
  int status;
  String message;
  String user_id;
  String token;

  LoginResponse.fromJSON(dynamic data) {
    if (data != null) {
      status = data['status'];
      message = data['message'];
      user_id = data['user_id'];
      token = data['token'];
    }
  }

  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = user_id;
    data['token'] = token;
    return data;
  }
}
