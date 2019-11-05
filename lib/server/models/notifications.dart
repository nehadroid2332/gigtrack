import 'package:gigtrack/base/base_model.dart';

class Notification extends BaseModel {
  String id;
  String userId;
  int created;
  bool status = false;
  String notiId;
  String bandId;
  //1-> Band
  //2 -> Activity
  //3-> EPK
  //4-> Contact
  //5-> Notes
  //6-> Member Add
  int type = 0;

  String text;

  Notification({
    this.text,
    this.type,
    this.bandId,
    this.notiId,
    this.status,
    this.created,
    this.userId,
    this.id,
  });

  Notification.fromJSON(dynamic data) {
    id = data['id'];
    userId = data['userId'];
    created = data['created'];
    status = data['status'];
    notiId = data['notiId'];
    bandId = data['bandId'];
    type = data['type'];
    text = data['text'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['userId'] = userId;
    data['created'] = created;
    data['status'] = status;
    data['notiId'] = notiId;
    data['bandId'] = bandId;
    data['type'] = type;
    data['text'] = text;
    return data;
  }
}
