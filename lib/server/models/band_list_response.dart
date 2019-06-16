import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class BandListResponse extends BaseModel {
  int status;
  List<Band> bandList = [];

  BandListResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      for (var d in data['data']) {
        bandList.add(Band.fromJSON(d));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    final list = <dynamic>[];
    for (var b in bandList) {
      list.add(b.toMap());
    }
    data['data'] = list;
    return data;
  }
}
