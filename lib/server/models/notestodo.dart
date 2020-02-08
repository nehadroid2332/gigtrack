import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class NotesTodo extends BaseModel {
  static const TYPE_NOTE = 0;
  static const TYPE_IDEA = 1;

  int type = TYPE_NOTE;
  String description;
  int startDate;
  int endDate;
  String id;
  String userId;
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
      this.endDate,
      this.startDate,
      this.type,
      this.bandId,
      this.id,
      this.note,
      this.createdDate});

  NotesTodo.fromJSON(dynamic data) {
    type = data['type'] ?? TYPE_NOTE;
    description = data['description'];
    startDate = data['start_date'];
    endDate = data['end_date'];
    id = data['id'];
    userId = data['user_id'];
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
    data['start_date'] = startDate ?? 0;
    data['end_date'] = endDate ?? 0;
    data['id'] = id ?? "";
    data['isArchive'] = isArchive ?? false;
    data['bandId'] = bandId;
    data['user_id'] = userId ?? "";
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
