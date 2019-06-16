import 'package:gigtrack/base/base_model.dart';

class NoteTodoResponse extends BaseModel {
  int status;
  String message;
  int id;

  NoteTodoResponse({this.id, this.status, this.message});

  NoteTodoResponse.fromJSON(dynamic data) {
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