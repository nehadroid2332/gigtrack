import 'package:gigtrack/base/base_model.dart';

class NotesTodo extends BaseModel {
  int type;
  String description;
  int start_date;
  int end_date;
  String id;
  String user_id;
  String note;

  NotesTodo({this.description, this.end_date, this.start_date, this.type, this.id,this.note});

  NotesTodo.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    start_date = data['start_date'];
    end_date = data['end_date'];
    id = data['id'];
    user_id = data['user_id'];
    note=data['note'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['description'] = description ?? "";
    data['start_date'] = start_date ?? 0;
    data['end_date'] = end_date ?? 0;
    data['id'] = id ?? "";
    data['user_id'] = user_id ?? "";
    data['note']=note??"";
    return data;
  }
}
