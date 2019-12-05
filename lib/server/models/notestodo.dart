import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class NotesTodo extends BaseModel {
  int type;
  String description;
  int start_date;
  int end_date;
  String id;
  String user_id;
  String note;
  int createdDate;
  String bandId;
  Band band;
  List<NotesTodo> subNotes = [];

  NotesTodo(
      {this.description,
      this.end_date,
      this.start_date,
      this.type,
      this.bandId,
      this.id,
      this.note,
      this.createdDate});

  NotesTodo.fromJSON(dynamic data) {
    type = data['type'];
    description = data['description'];
    start_date = data['start_date'];
    end_date = data['end_date'];
    id = data['id'];
    user_id = data['user_id'];
    bandId = data['bandId'];
    note = data['note'];
    createdDate = data['createdDate'];
    if (data['subNotes'] != null) {
      for (var item in data['subNotes']) {
        subNotes.add(NotesTodo.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['type'] = type;
    data['description'] = description ?? "";
    data['start_date'] = start_date ?? 0;
    data['end_date'] = end_date ?? 0;
    data['id'] = id ?? "";
    data['bandId'] = bandId;
    data['user_id'] = user_id ?? "";
    data['note'] = note ?? "";
    data['createdDate'] = createdDate ?? 0;
    List<dynamic> sb = [];
    for (NotesTodo item in subNotes) {
      sb.add(item.toMap());
    }
    data['subNotes'] = sb;
    return data;
  }
}
