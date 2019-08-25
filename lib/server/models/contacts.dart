import 'dart:io';

import 'package:gigtrack/base/base_model.dart';

class Contacts extends BaseModel {
  String name;
  String relationship;
  String phone;
  String text;
  String email;
  String dateToRemember;

  List<File> files = [];
  List<String> uploadedFiles = [];

  Contacts.fromJSON(dynamic data) : super.fromJSON(data) {
    name = data['name'];
    relationship = data['relationship'];
    phone = data['phone'];
    text = data['text'];
    email = data['email'];
    dateToRemember = data['dateToRemember'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['name'] = name;
    data['relationship'] = relationship;
    data['phone'] = phone;
    data['text'] = text;
    data['email'] = email;
    data['dateToRemember'] = dateToRemember;
    return data;
  }
}
