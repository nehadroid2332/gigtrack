import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band.dart';

class BandDetailsResponse extends BaseModel {
  int status;
  Band band;

  BandDetailsResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      band = Band.fromJSON(data['data']);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    data['data'] = band.toMap();
    return data;
  }
}
