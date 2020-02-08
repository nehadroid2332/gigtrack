import 'package:gigtrack/base/base_model.dart';

class LoginResponse extends BaseModel {
  int status;
  String message;
  String userId;
  String token;

  LoginResponse.fromJSON(dynamic data) {
    if (data != null) {
      status = data['status'];
      message = data['message'];
      userId = data['user_id'];
      token = data['token'];
    }
  }

  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = userId;
    data['token'] = token;
    return data;
  }
}
