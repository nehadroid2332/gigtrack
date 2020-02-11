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
  int status = STATUS_PENDING;
  List<SubNotesBandComm> subNotes = [];

  static const STATUS_APPROVED = 1;
  static const STATUS_DECLINED = 2;
  static const STATUS_PENDING = 0;

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
    status = data['status'];
    if (data['subNotes'] != null) {
      for (var item in data['subNotes']) {
        subNotes.add(SubNotesBandComm.fromJSON(item));
      }
    }
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
    data['status'] = status;
    List<dynamic> sb = [];
    for (SubNotesBandComm item in subNotes) {
      sb.add(item.toMap());
    }
    data['subNotes'] = sb;
    return data;
  }
}

class SubNotesBandComm extends BaseModel {
  String desc;
  int created;
  String id;
  SubNotesBandComm();

  SubNotesBandComm.fromJSON(dynamic data) {
    desc = data['desc'];
    id = data['id'];
    created = data['created'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['desc'] = desc;
    data['id'] = id;
    data['created'] = created;
    return data;
  }
}
