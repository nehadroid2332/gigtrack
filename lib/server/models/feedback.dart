import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/user.dart';

class UserFeedback extends BaseModel {
  String message;
  String userId;
  String id;
  User user;

  UserFeedback({this.userId, this.message, this.id});

  UserFeedback.fromJSON(dynamic data) {
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
