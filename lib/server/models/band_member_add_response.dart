import 'package:gigtrack/base/base_model.dart';

class BandMemberAddResponse extends BaseModel {
  int status;
  String message;
  int id;

  BandMemberAddResponse.fromJSON(dynamic data) {
    status = data['status'];
    message = data['message'];
    id = data['id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    data['message'] = message;
    data['id'] = id;
    return data;
  }
}
