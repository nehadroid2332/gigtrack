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
  int endDate;
  int taskCompleteDate;
  String location;
  String notes = "";
  String travel = "";
  String id;
  String task = "";
  String userId;
  String wardrobe;
  String parking;
  String other;
  String bandId;
  bool isRecurring = false;

  List<Activites> subActivities = [];

  Activites(
      {this.description,
      this.location,
      this.startDate,
      this.endDate,
      this.type,
      this.id,
      this.wardrobe,
      this.parking,
      this.isRecurring,
      this.taskCompleteDate,
      this.other,
      this.bandId,
      this.title});

  Activites.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    startDate = data['start_date'];
    endDate = data['end_date'];
    location = data['location'];
    title = data['title'];
    travel = data['travel'];
    wardrobe = data['wardrobe'];
    parking = data['parking'];
    isRecurring = data['isRecurring'];
    other = data['other'];
    bandId = data['bandId'];
    notes = data['notes'];
    task = data['task'];
    taskCompleteDate = data['taskCompleteDate'];
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
    data['end_date'] = endDate ?? 0;
    data['location'] = location ?? "";
    data['task'] = task ?? "";
    data['travel'] = travel ?? "";
    data['notes'] = notes ?? "";
    data['title'] = title ?? "";
    data['id'] = id ?? "";
    data['bandId'] = bandId;
    data['isRecurring'] = isRecurring;
    data['taskCompleteDate'] = taskCompleteDate;
    data['parking'] = parking;
    data['wardrobe'] = wardrobe;
    data['other'] = other;
    data['user_id'] = userId;
    List<dynamic> sb = [];
    for (Activites item in subActivities) {
      sb.add(item.toMap());
    }
    data['subActivities'] = sb;
    return data;
  }
}
