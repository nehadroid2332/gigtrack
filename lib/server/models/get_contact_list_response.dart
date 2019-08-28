import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/contacts.dart';

class GetContactListResponse extends BaseModel {
  int status;
  List<Contacts> data = [];

  GetContactListResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      for (var item in data['data']) {
        this.data.add(Contacts.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    List<dynamic> ld = [];
    for (Contacts d in this.data) {
      ld.add(d.toMap());
    }
    data['data'] = ld;
    return data;
  }
}
