import 'package:gigtrack/base/base_model.dart';

class Activites extends BaseModel {
  int type;
  int band_id;
  int action_type;
  String title;
  String description;
  String date;
  String location;

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
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['description'] = description;
    data['date'] = date;
    data['location'] = location;
    data['title'] = title;
    data['action_type'] = action_type;
    data['band_id'] = band_id;
    return data;
  }
}
