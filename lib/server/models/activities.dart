import 'package:gigtrack/base/base_model.dart';

class Activites extends BaseModel {
  int type;
  String band_id;
  int action_type;
  String title;
  String description;
  int startDate;
  int endDate;
  String location;
  String notes = "";
  String travel = "";
  String id;
  String task = "";
  String userId;

  Activites(
      {this.description,
      this.location,
      this.startDate,
      this.type,
      this.id,
      this.endDate,
      this.action_type,
      this.band_id,
      this.title});

  Activites.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    startDate = data['start_date'];
    endDate = data['end_date'];
    location = data['location'];
    band_id = data['band_id'];
    action_type = data['action_type'];
    title = data['title'];
    travel = data['travel'];
    notes = data['notes'];
    task = data['task'];
    id = data['id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['description'] = description ?? "";
    data['start_date'] = startDate ?? "";
    data['end_date'] = endDate ?? "";
    data['location'] = location ?? "";
    data['task'] = task ?? "";
    data['travel'] = travel ?? "";
    data['notes'] = notes ?? "";
    data['title'] = title ?? "";
    data['action_type'] = action_type;
    data['id'] = id ?? "";
    data['user_id'] = userId;
    data['band_id'] = band_id ?? "";
    return data;
  }
}
