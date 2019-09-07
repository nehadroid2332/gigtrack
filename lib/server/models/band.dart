import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/user.dart';

class Band extends BaseModel {
  String name;
  String legalName;
  String legalStructure;
  int dateStarted;
  String musicStyle;
  String email;
  String website;

  String id;
  String userId;

  Map<String, int> bandmates = Map();
  List<User> bandmateUsers = [];

  Band(
      {this.dateStarted,
      this.email,
      this.legalName,
      this.legalStructure,
      this.musicStyle,
      this.name,
      this.website});

  Band.fromJSON(dynamic data) {
    name = data['name'];
    legalName = data['legal_name'];
    legalStructure = data['legal_structure'];
    dateStarted = data['date_started'];
    musicStyle = data['music_style'];
    email = data['email'];
    website = data['website'];
    id = data['id'];
    userId = data['user_id'];
    if (data['bandmates'] != null) {
      bandmates.clear();
      Map map = data['bandmates'];
      for (MapEntry item in map.entries) {
        bandmates[item.key] = item.value;
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['name'] = name ?? "";
    data['legal_name'] = legalName ?? "";
    data['legal_structure'] = legalStructure ?? "";
    data['date_started'] = dateStarted ?? "";
    data['music_style'] = musicStyle ?? "";
    data['user_id'] = userId;
    data['email'] = email ?? "";
    data['website'] = website ?? "";
    data['id'] = id;
    data['bandmates'] = bandmates;
    return data;
  }
}
