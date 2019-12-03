import 'package:gigtrack/base/base_model.dart';

class Feedback extends BaseModel {
  String message;
  String userId;
  String id;

  Feedback({this.userId, this.message, this.id});

  Feedback.fromJSON(dynamic data) {
    message = data['message'];
    userId = data['userId'];
    id = data['id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map();
    data['message'] = message;
    data['userId'] = userId;
    data['id'] = id;
    return data;
  }
}
