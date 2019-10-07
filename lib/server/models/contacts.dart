import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/ui/addcontact/add_contact_screen.dart';

class Contacts extends BaseModel {
  String name;
  String relationship;
  String phone;
  String text;
  String email;
  String otherrelationship;
  List<DateToRememberData> dateToRemember = [];
  String id;
  String user_id;
  List<String> files = [];
  Map<String, String> likeadded = {};
  String companyName;
  String notes;
  String bandId;

  Contacts();

  Contacts.fromJSON(dynamic data) : super.fromJSON(data) {
    name = data['name'];
    relationship = data['relationship'];
    phone = data['phone'];
    text = data['text'];
    email = data['email'];
    id = data['id'];
    bandId = data['bandId'];
    user_id = data['user_id'];
    otherrelationship = data['other_relationship'];
    companyName = data['companyName'];
    notes = data['notes'];
    if (data['files'] != null) {
      for (String item in data['files']) {
        files.add(item);
      }
    }
    if (data['date_to_remember'] != null) {
      for (var item in data['date_to_remember']) {
        dateToRemember.add(DateToRememberData.fromJSON(item));
      }
    }
    if (data['likes'] != null) {
      Map map = data['likes'];
      for (var p in map.keys) {
        likeadded[p.toString()] = (map[p]).toString();
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['name'] = name;
    data['relationship'] = relationship;
    data['phone'] = phone;
    data['text'] = text;
    data['email'] = email;
    data['bandId'] = bandId;
    List<dynamic> dtR = [];
    for (var item in dateToRemember) {
      dtR.add(item.toMap());
    }
    data['likes'] = likeadded;
    data['date_to_remember'] = dtR;
    data['files'] = files;
    data['user_id'] = user_id;
    data['id'] = id;
    data['other_relationship'] = otherrelationship;
    data['companyName'] = companyName;
    data['notes'] = notes;
    return data;
  }
}
