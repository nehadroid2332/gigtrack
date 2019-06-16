import 'package:gigtrack/base/base_model.dart';

class NotesTodo extends BaseModel {
  int type;
  String description;
  String start_date;
  String end_date;

  NotesTodo({this.description, this.end_date, this.start_date, this.type});

  NotesTodo.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    start_date = data['start_date'];
    end_date = data['end_date'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['description'] = description;
    data['start_date'] = start_date;
    data['end_date'] = end_date;
    return data;
  }
}
