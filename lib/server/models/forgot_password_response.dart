import 'package:gigtrack/base/base_model.dart';

class ForgetPasswordResponse extends BaseModel {
  int status;
  String message;

  ForgetPasswordResponse({this.status, this.message});

  ForgetPasswordResponse.fromJSON(dynamic data) {
    status = data['status'];
    message = data['message'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
