import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/user.dart';

class SearchUserResponse extends BaseModel {
  int status;
  List<User> users = [];

  SearchUserResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      for (var d in data['data']) {
        users.add(User.fromJSON(d));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    List<dynamic> usrs = [];
    for (User u in users) {
      usrs.add(u.toMap());
    }
    data['data'] = usrs;
    return data;
  }
}
