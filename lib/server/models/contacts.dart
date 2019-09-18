import 'dart:io';

import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/ui/addcontact/add_contact_screen.dart';

class Contacts extends BaseModel {
  String name;
  String relationship;
  String phone;
  String text;
  String email;
  List<DateToRememberData> dateToRemember=[];
  String id;
  String user_id;
  List<String> files = [];
  List<LikesData> likeadded=[];

  Contacts();

  Contacts.fromJSON(dynamic data) : super.fromJSON(data) {
    name = data['name'];
    relationship = data['relationship'];
    phone = data['phone'];
    text = data['text'];
    email = data['email'];
    id = data['id'];
    user_id = data['user_id'];
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
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['name'] = name;
    data['relationship'] = relationship;
    data['phone'] = phone;
    data['text'] = text;
    data['email'] = email;
    List<dynamic> dtR = [];
    for (var item in dateToRemember) {
      dtR.add(item.toMap());
    }
    data['date_to_remember'] = dtR;
    data['files'] = files;
    data['user_id'] = user_id;
    data['id'] = id;
    return data;
  }
}
