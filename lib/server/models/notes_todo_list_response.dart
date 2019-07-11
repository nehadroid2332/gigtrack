import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/notestodo.dart';

class GetNotesTodoListResponse extends BaseModel {
  int status;
  List<NotesTodo> data = <NotesTodo>[];

  GetNotesTodoListResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      for (var d in data['data']) {
        final dd = NotesTodo.fromJSON(d);
        this.data.add(dd);
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data1 = super.toMap();
    data1['status'] = status;
    List<dynamic> dd = [];
    for (NotesTodo d in data) {
      dd.add(d.toMap());
    }
    data1['data'] = dd;
    return data1;
  }
}
