import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/activities.dart';

class GetActivitiesListResponse extends BaseModel {
  int status;
  List<Activites> data = [];

  GetActivitiesListResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      for (var d in data['data']) {
        final dd = Activites.fromJSON(d);
        data.add(dd);
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data1 = super.toMap();
    data1['status'] = status;
    List<dynamic> dd = [];
    for (Activites d in data) {
      dd.add(d.toMap());
    }
    data1['data'] = dd;
    return data1;
  }
}
