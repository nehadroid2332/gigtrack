import 'package:gigtrack/base/base_model.dart';

class AppNotification extends BaseModel {
  static const TYPE_BAND = 1;
  static const TYPE_ACTIVITY = 2;
  static const TYPE_EPK = 3;
  static const TYPE_CONTACT = 4;
  static const TYPE_NOTES = 5;
  static const TYPE_MEMBER_ADD = 6;
  static const TYPE_INSTRUMENT = 7;
  static const TYPE_BULLETIN_BOARD = 8;
  static const TYPE_SET_LIST = 9;
  static const TYPE_BAND_COMM = 10;

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

  AppNotification({
    this.text,
    this.type,
    this.bandId,
    this.notiId,
    this.status,
    this.created,
    this.userId,
    this.id,
  });

  AppNotification.fromJSON(dynamic data) {
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
