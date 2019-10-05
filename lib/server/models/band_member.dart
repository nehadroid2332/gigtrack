import 'package:gigtrack/base/base_model.dart';

class BandMember extends BaseModel {
  String id;
  String user_id;
  String firstName;
  String lastName;
  String email;
  String mobileText;
  String permissions;
  String payInfo;
  List<String> memberRole=[];
  String instrument;
  String other;
  String otherTalent;
  String notes;
  String pay;
  int status = 0;

  BandMember(
      {this.user_id,
      this.otherTalent,
      this.permissions,
      this.payInfo,
      this.email,
      this.firstName,
      this.lastName,
      this.mobileText,
      this.memberRole,
      this.instrument,
      this.other,
      this.id,
      this.status,
      this.notes,
      this.pay});

  BandMember.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    email = data['email'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    mobileText = data['mobileText'];
    notes = data['notes'];
    pay = data['pay'];
    otherTalent = data['otherTalent'];
    if (data['memberRole'] != null) {
      for (var item in data['memberRole']) {
        memberRole.add(item.toString());
      }
    }
    status = data['status'] ?? 0;
    payInfo = data['payInfo'];
    permissions = data['permissions'];
    instrument = data['instrument'];
    other = data['other'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = user_id;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileText'] = mobileText;
    data['otherTalent'] = otherTalent;
    data['pay'] = pay;
    data['status'] = status;
    data['notes'] = notes;
    data['permissions'] = permissions;
    data['payInfo'] = payInfo;
    data['memberRole'] = memberRole;
    data['instrument'] = instrument;
    data['other'] = other;
    return data;
  }
}
