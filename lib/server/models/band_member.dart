import 'package:gigtrack/base/base_model.dart';

class BandMember extends BaseModel {
  String id;
  String user_id;
  String band_id;
  String bandmate_id;

  BandMember.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    band_id = data['band_id'];
    bandmate_id = data['bandmate_id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = user_id;
    data['band_id'] = band_id;
    data['bandmate_id'] = bandmate_id;
    return data;
  }
}
