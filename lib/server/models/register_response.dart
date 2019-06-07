import 'package:gigtrack/base/base_model.dart';

class RegisterResponse extends BaseModel {
  int status;
  String message;

  RegisterResponse.fromJSON(dynamic data) {
    status = data['status'];
    message = data['message'];
  }

  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
