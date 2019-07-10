import 'package:gigtrack/base/base_model.dart';

class NotesTodo extends BaseModel {
  String type;
  String description;
  String start_date;
  String end_date;
  String id;
  String user_id;

  NotesTodo({this.description, this.end_date, this.start_date, this.type});

  NotesTodo.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    start_date = data['start_date'];
    end_date = data['end_date'];
    id = data['id'];
    user_id = data['user_id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = "$type";
    data['description'] = description ?? "";
    data['start_date'] = start_date ?? "";
    data['end_date'] = end_date ?? "";
    data['id'] = id ?? "";
    data['user_id'] = user_id ?? "";
    return data;
  }
}
