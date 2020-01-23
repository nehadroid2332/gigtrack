import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class NotesTodo extends BaseModel {
  static const TYPE_NOTE = 0;
  static const TYPE_IDEA = 1;

  int type = TYPE_NOTE;
  String description;
  int start_date;
  int end_date;
  String id;
  String user_id;
  String note;
  int createdDate;
  String bandId;
  Band band;
  bool isArchive = false;
  int status = STATUS_PENDING;

  static const STATUS_APPROVED = 1;
  static const STATUS_DECLINED = 2;
  static const STATUS_PENDING = 0;

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
    type = data['type'] ?? TYPE_NOTE;
    description = data['description'];
    start_date = data['start_date'];
    end_date = data['end_date'];
    id = data['id'];
    user_id = data['user_id'];
    bandId = data['bandId'];
    note = data['note'];
    status = data['status'];
    isArchive = data['isArchive'] ?? false;
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
    data['type'] = type ?? TYPE_NOTE;
    data['status'] = status;
    data['description'] = description ?? "";
    data['start_date'] = start_date ?? 0;
    data['end_date'] = end_date ?? 0;
    data['id'] = id ?? "";
    data['isArchive'] = isArchive ?? false;
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
