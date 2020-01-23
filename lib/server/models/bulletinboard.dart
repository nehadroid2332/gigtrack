import 'package:gigtrack/base/base_model.dart';

class BulletInBoard extends BaseModel {
  String item;
  int date;
  String type;
  String description;
  String id;
  String user_id;
  int visibleDays;
  int created = DateTime.now().millisecondsSinceEpoch;
  int status = STATUS_PENDING;

  static const STATUS_APPROVED = 1;
  static const STATUS_DECLINED = 2;
  static const STATUS_PENDING = 0;

  BulletInBoard(
      {this.date,
      this.item,
      this.description,
      this.type,
      this.id,
      this.user_id,
      this.status});

  BulletInBoard.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    item = data['item'];
    date = data['date'];
    type = data['type'];
    description = data['description'];
    status = data['status'];
    visibleDays = data['visibleDays'];
    created = data['created'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['item'] = item;
    data['id'] = id;
    data['user_id'] = user_id;
    data['date'] = date;
    data['type'] = type;
    data['status'] = status;
    data['visibleDays'] = visibleDays;
    data['created'] = created;
    data['description'] = description;
    return data;
  }
}
