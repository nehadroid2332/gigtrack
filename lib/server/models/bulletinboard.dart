import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/user.dart';

class BulletInBoard extends BaseModel {
  String item;
  int date;
  String type;
  String description;
  String id;
  String userId;
  int visibleDays;
  String city;
  String state;
  bool isrecurring;
  List<dynamic> uploadedFiles = [];
  int created = DateTime.now().millisecondsSinceEpoch;
  int status = STATUS_PENDING;

  static const STATUS_APPROVED = 1;
  static const STATUS_DECLINED = 2;
  static const STATUS_PENDING = 0;

  User user;

  BulletInBoard(
      {this.date,
      this.item,
      this.description,
      this.type,
      this.id,
      this.userId,
      this.uploadedFiles,
      this.status,
      this.city,
      this.state,
        this.isrecurring
      });

  BulletInBoard.fromJSON(dynamic data) {
    id = data['id'];
    userId = data['user_id'];
    item = data['item'];
    date = data['date'];
    type = data['type'];
    description = data['description'];
    status = data['status'];
    visibleDays = data['visibleDays'];
    created = data['created'];
    city=data['city'];
    state= data['state'];
    isrecurring=data['isrecurring'];
    if (data['uploadedFiles'] != null)
      this.uploadedFiles = data['uploadedFiles'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['item'] = item;
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['type'] = type;
    data['status'] = status;
    data['visibleDays'] = visibleDays;
    data['created'] = created;
    data['description'] = description;
    data['uploadedFiles'] = uploadedFiles;
    data['city']= city;
    data['isrecurring']= isrecurring;
    data['state']=state;
    return data;
  }
}
