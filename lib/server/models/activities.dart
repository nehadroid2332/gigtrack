import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/user.dart';

class Activites extends BaseModel {
  String type;
  String band_id;
  String action_type;
  String title;
  String description;
  String date;
  String location;
  String id;

  List<User> bandmates = [];

  Activites(
      {this.description,
      this.location,
      this.date,
      this.type,
      this.action_type,
      this.band_id,
      this.title});

  Activites.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    date = data['date'];
    location = data['location'];
    band_id = data['band_id'];
    action_type = data['action_type'];
    title = data['title'];
    id = data['id'];
    if (data['bandmates'] != null) {
      for (var b in data['bandmates']) {
        if (b != null) {
          User u = User.fromJSON(b[0]);
          if (b.length > 1) u.status = b[1]['status'];
          bandmates.add(u);
        }
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = "$type";
    data['description'] = description;
    data['date'] = date;
    data['location'] = location;
    data['title'] = title;
    data['action_type'] = "$action_type";
    data['id'] = id ?? "";
    data['band_id'] = band_id ?? "";
    List<dynamic> bnds = [];
    for (var b in bandmates) {
      bnds.add(b.toMap());
    }
    if (bnds.length > 0) data['bandmates'] = bnds;
    return data;
  }
}
