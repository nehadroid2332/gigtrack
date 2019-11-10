import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class Activites extends BaseModel {
  static const TYPE_ACTIVITY = 0;
  static const TYPE_PERFORMANCE_SCHEDULE = 1;
  static const TYPE_PRACTICE_SCHEDULE = 2;
  static const TYPE_TASK = 3;
  static const TYPE_BAND_TASK = 4;

  int type;
  String title;
  String description;
  int startDate;
  int endDate;
  int taskCompleteDate;
  int estCompleteDate;
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
  String bandTaskId;
  String bandTaskMemberId;
  bool isRecurring = false;
  double latitude = 0.toDouble();
  double longitude = 0.toDouble();
  Band band;

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
      this.estCompleteDate,
      this.latitude,
      this.longitude,
      this.title,
      this.bandTaskId,
      this.bandTaskMemberId});

  Activites.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    startDate = data['start_date'];
    endDate = data['end_date'];
    location = data['location'];
    latitude = double.parse("${data['latitude'] ?? 0.0}");
    longitude = double.parse("${data['longitude'] ?? 0.0}");
    title = data['title'];
    travel = data['travel'];
    estCompleteDate = data['estCompleteDate'];
    wardrobe = data['wardrobe'];
    parking = data['parking'];
    isRecurring = data['isRecurring'];
    other = data['other'];
    bandId = data['bandId'];
    bandTaskId = data['bandTaskId'];
    bandTaskMemberId = data['bandTaskMemberId'];
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
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['task'] = task ?? "";
    data['travel'] = travel ?? "";
    data['estCompleteDate'] = estCompleteDate;
    data['notes'] = notes ?? "";
    data['bandTaskMemberId'] = bandTaskMemberId ?? "";
    data['bandTaskId'] = bandTaskId ?? "";
    data['title'] = title ?? "";
    data['id'] = id ?? "";
    data['bandId'] = bandId;
    data['isRecurring'] = isRecurring;
    data['taskCompleteDate'] = taskCompleteDate ?? 0;
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
