import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class Activites extends BaseModel {
  static const TYPE_ACTIVITY = 0;
  static const TYPE_PERFORMANCE_SCHEDULE = 1;
  static const TYPE_PRACTICE_SCHEDULE = 2;
  static const TYPE_TASK = 3;
  static const TYPE_BAND_TASK = 4;
  static const TYPE_APPOINTMENT=5;

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
  String startTime;
  String endTime;
  String bandId;
  String bandTaskId;
  String bandTaskMemberId;
  bool isRecurring = false;
  double latitude = 0.toDouble();
  double longitude = 0.toDouble();
  Band band;
  String startEventTime;
  String endEventTime;

  List<Activites> subActivities = [];
  List<Travel> travelList = [];

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
      this.travelList,
      this.bandTaskId,
      this.bandTaskMemberId,
      this.startEventTime,
      this.endEventTime,
      this.startTime,
      this.endTime});

  Activites.fromJSON(dynamic data) {
    startEventTime = data['startEventTime'];
    endEventTime = data['endEventTime'];
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
    startTime = data['startTime'];
    userId=data['user_id'];
    endTime = data['endTime'];
    taskCompleteDate = data['taskCompleteDate'];
    id = data['id'];
    if (data['subActivities'] != null) {
      for (var item in data['subActivities']) {
        subActivities.add(Activites.fromJSON(item));
      }
    }
    if (data['travelList'] != null) {
      for (var item in data['travelList']) {
        travelList.add(Travel.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['startEventTime'] = startEventTime;
    data['endEventTime'] = endEventTime;
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

    List<dynamic> tr = [];
    if (travelList != null)
      for (Travel item in travelList) {
        tr.add(item.toMap());
      }
    data['travelList'] = tr;

    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}

class Travel extends BaseModel {
  String id;
  List<ShowUps> showupList = [];
  List<Sleeping> sleepingList = [];
  List<Flight> flightList = [];
  String location;
  int startDate;
  int endDate;
  String notes;

  Travel();

  Travel.fromJSON(dynamic data) {
    id = data['id'];
    location = data['location'];
    startDate = data['startDate'];
    endDate = data['endDate'];
    notes = data['notes'];
    if (data['showupList'] != null) {
      for (var item in data['showupList']) {
        showupList.add(ShowUps.fromJSON(item));
      }
    }
    if (data['sleepingList'] != null) {
      for (var item in data['sleepingList']) {
        sleepingList.add(Sleeping.fromJSON(item));
      }
    }
    if (data['flightList'] != null) {
      for (var item in data['flightList']) {
        flightList.add(Flight.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['location'] = location;
    data['id'] = id;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['notes'] = notes;
    List<dynamic> shl = [];
    for (var item in showupList) {
      shl.add(item.toMap());
    }
    data['showupList'] = shl;

    List<dynamic> sll = [];
    for (var item in sleepingList) {
      sll.add(item.toMap());
    }
    data['sleepingList'] = sll;

    List<dynamic> fll = [];
    for (var item in flightList) {
      fll.add(item.toMap());
    }
    data['flightList'] = fll;

    return data;
  }
}

class ShowUps extends BaseModel {
  String location;
  int dateTime;

  ShowUps();
  ShowUps.fromJSON(dynamic data) {
    location = data['location'];
    dateTime = data['dateTime'];
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['location'] = location;
    data['dateTime'] = dateTime;
    return data;
  }
}

class Sleeping extends BaseModel {
  String location;
  int fromDate;
  int toDate;
  String address;
  Sleeping();
  Sleeping.fromJSON(dynamic data) {
    location = data['location'];
    fromDate = data['fromDate'];
    toDate = data['toDate'];
    address= data['address'];
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['location'] = location;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['address']= address;
    return data;
  }
}

class Flight extends BaseModel {
  int departureDateTime;
  int arrivalDateTime;
  String airline;
  String flight;
  String toAirport;
  String fromAirport;
  String recordLocator;

  Flight();

  Flight.fromJSON(dynamic data) {
    departureDateTime = data['departureDateTime'];
    arrivalDateTime = data['arrivalDateTime'];
    airline = data['airline'];
    flight = data['flight'];
    toAirport = data['toAirport'];
    fromAirport = data['fromAirport'];
    recordLocator= data['recordLocator'];
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['departureDateTime'] = departureDateTime;
    data['arrivalDateTime'] = arrivalDateTime;
    data['airline'] = airline;
    data['flight'] = flight;
    data['toAirport'] = toAirport;
    data['fromAirport'] = fromAirport;
    data['recordLocator']= recordLocator;
    return data;
  }
}
