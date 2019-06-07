import 'package:gigtrack/base/base_model.dart';

class ErrorResponse extends BaseModel {
  int status;
  String message;

  ErrorResponse.fromJSON(dynamic data) {
    if (data != null) {
      if (data is String) {
        message = data;
      } else {
        status = data['status'];
        if (data['message'] != null) {
          if (data['message'] is String) {
            message = data['message'];
          } else {
            final res = data['message'];
            if (res != null) {
              message = res['email'];
            }
          }
        }
      }
    }
  }
}
