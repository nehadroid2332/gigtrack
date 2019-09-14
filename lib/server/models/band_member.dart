import 'package:gigtrack/base/base_model.dart';

class BandMember extends BaseModel {
  String id;
  String user_id;
  String stageName;
  String authField;
  List<String> permissions = [];
  String payInfo;
  String memberRole;
  String instrument;
  String other;

  BandMember({
    this.user_id,
    this.stageName,
    this.authField,
    this.permissions,
    this.payInfo,
    this.memberRole,
    this.instrument,
    this.other,
  });

  BandMember.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    stageName = data['stageName'];
    authField = data['authField'];
    if (data['permissions'] != null) {
      for (var item in data['permissions']) {
        permissions.add(item.toString());
      }
    }
    payInfo = data['payInfo'];
    memberRole = data['memberRole'];
    instrument = data['instrument'];
    other = data['other'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = user_id;
    data['stageName'] = stageName;
    data['authField'] = authField;
    data['permissions'] = permissions;
    data['payInfo'] = payInfo;
    data['memberRole'] = memberRole;
    data['instrument'] = instrument;
    data['other'] = other;
    return data;
  }
}
