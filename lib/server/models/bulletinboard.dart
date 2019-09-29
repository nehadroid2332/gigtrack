import 'package:gigtrack/base/base_model.dart';

class BulletInBoard extends BaseModel {
  String item;
  int date;
  String type;
  String description;
  String id;
  String user_id;

  BulletInBoard({
    this.date,
    this.item,
    this.description,
    this.type,
    this.id,
    this.user_id,
  });

  BulletInBoard.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    item = data['item'];
    date = data['date'];
    type = data['type'];
    description = data['description'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['item'] = item;
    data['id'] = id;
    data['user_id'] = user_id;
    data['date'] = date;
    data['type'] = type;
    data['description'] = description;
    return data;
  }
}
