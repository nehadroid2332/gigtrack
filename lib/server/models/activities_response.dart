import 'package:gigtrack/base/base_model.dart';

class ActivitiesResponse extends BaseModel {
  int status;
  String message;
  int id;

  ActivitiesResponse({this.id, this.status, this.message});

  ActivitiesResponse.fromJSON(dynamic data) {
    status = data['status'];
    message = data['message'];
    id = data['id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}