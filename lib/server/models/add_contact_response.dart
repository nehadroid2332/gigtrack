import 'package:gigtrack/base/base_model.dart';

class AddContactResponse extends BaseModel {
  int status;
  int id;
  String message;

  AddContactResponse.fromJSON(dynamic data) {
    status = data['status'];
    id = data['id'];
    message = data['message'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    data['id'] = id;
    data['message'] = message;
    return data;
  }
}
