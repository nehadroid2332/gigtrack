import 'package:gigtrack/base/base_model.dart';

class AddBandResponse extends BaseModel {
  int status;
  int id;
  String message;

  AddBandResponse.fromJSON(dynamic data) {
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
