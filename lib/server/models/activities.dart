import 'package:gigtrack/base/base_model.dart';

class Activites extends BaseModel {
  static const TYPE_ACTIVITY = 0;
  static const TYPE_PERFORMANCE_SCHEDULE = 1;
  static const TYPE_PRACTICE_SCHEDULE = 2;
  static const TYPE_TASK = 3;

  int type;
  String title;
  String description;
  int startDate;
  String location;
  String notes = "";
  String travel = "";
  String id;
  String task = "";
  String userId;
  List<Activites> subActivities = [];

  Activites(
      {this.description,
      this.location,
      this.startDate,
      this.type,
      this.id,
      this.title});

  Activites.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    startDate = data['start_date'];
    location = data['location'];
    title = data['title'];
    travel = data['travel'];
    notes = data['notes'];
    task = data['task'];
    id = data['id'];
    if (data['subActivities'] != null) {
      for (var item in data['subActivities']) {
        subActivities.add(Activites.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['description'] = description ?? "";
    data['start_date'] = startDate ?? 0;
    data['location'] = location ?? "";
    data['task'] = task ?? "";
    data['travel'] = travel ?? "";
    data['notes'] = notes ?? "";
    data['title'] = title ?? "";
    data['id'] = id ?? "";
    data['user_id'] = userId;
     List<dynamic> sb = [];
    for (Activites item in subActivities) {
      sb.add(item.toMap());
    }
    data['subActivities'] = sb;
    return data;
  }
}
