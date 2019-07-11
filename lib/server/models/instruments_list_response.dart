import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/instrument.dart';

class InstrumentListResponse extends BaseModel {
  int status;
  List<Instrument> data = [];

  InstrumentListResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['data'] != null) {
      for (var d in data['data']) {
        this.data.add(Instrument.fromJSON(d));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['status'] = status;

    List<dynamic> dts = [];
    for (Instrument i in this.data) {
      dts.add(i.toMap());
    }
    data['data'] = dts;
    return data;
  }
}
