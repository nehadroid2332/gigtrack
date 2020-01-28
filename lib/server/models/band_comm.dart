import 'package:gigtrack/base/base_model.dart';

class BandCommunication extends BaseModel {
  String title;
  String addCommunication;
  String priority;
  int responseDate;
  bool isArchieve;
  String id;
  String bandId;
  String userId;

  BandCommunication();

  BandCommunication.fromJSON(dynamic data) {
    id = data['id'];
    bandId = data['bandId'];
    userId = data['userId'];
    title = data['title'];
    addCommunication = data['addCommunication'];
    priority = data['priority'];
    responseDate = data['responseDate'];
    isArchieve = data['isArchieve'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['title'] = title;
    data['addCommunication'] = addCommunication;
    data['priority'] = priority;
    data['responseDate'] = responseDate;
    data['id'] = id;
    data['bandId'] = bandId;
    data['userId'] = userId;
    data['isArchieve'] = isArchieve;
    return data;
  }
}
