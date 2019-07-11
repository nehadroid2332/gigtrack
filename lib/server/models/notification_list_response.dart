import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/user.dart';

class NotificationListResponse extends BaseModel {
  int status;
  List<Activites> schedules = [];
  List<Activites> activities = [];
  List<User> users = [];
  List<Instrument> instruments = [];
  List<NotesTodo> todos = [];

  NotificationListResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['schedules'] != null) {
      for (var ds in data['schedules']) {
        schedules.add(Activites.fromJSON(ds));
      }
    }
    if (data['activities'] != null) {
      for (var ds in data['activities']) {
        activities.add(Activites.fromJSON(ds));
      }
    }
    if (data['equipments_warranty'] != null) {
      for (var ds in data['equipments_warranty']) {
        instruments.add(Instrument.fromJSON(ds));
      }
    }
    if (data['user_data'] != null) {
      for (var ds in data['user_data']) {
        users.add(User.fromJSON(ds));
      }
    }
    if (data['todo'] != null) {
      for (var ds in data['todo']) {
        todos.add(NotesTodo.fromJSON(ds));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['status'] = status;
    List<dynamic> acList = [];
    for (Activites a in activities) {
      acList.add(a.toMap());
    }
    data['activities'] = activities;

    List<dynamic> scList = [];
    for (Activites a in schedules) {
      scList.add(a.toMap());
    }
    data['schedules'] = schedules;

    List<dynamic> instr = [];
    for (Instrument a in instruments) {
      instr.add(a.toMap());
    }
    data['equipments_warranty'] = instr;

    List<dynamic> usrDt = [];
    for (User a in users) {
      usrDt.add(a.toMap());
    }
    data['user_data'] = usrDt;

    List<dynamic> todos = [];
    for (NotesTodo a in todos) {
      todos.add(a.toMap());
    }
    data['todo'] = todos;

    return data;
  }
}
