import 'package:gigtrack/base/base_model.dart';

class AddInstrumentResponse extends BaseModel {
  int status;
  String message;
  int id;

  AddInstrumentResponse.fromJSON(dynamic data) {
    status = data['status'];
    message = data['message'];
    id = data['id'];
  }

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['status'] = status;
    data['message'] = message;
    data['id'] = id;
    return data;
  }
}
