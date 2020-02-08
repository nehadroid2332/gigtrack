import 'package:gigtrack/base/base_model.dart';

class BandMember extends BaseModel {
  String id;
  String userId;
  String firstName;
  String lastName;
  String email;
  String mobileText;
  String permissions;
  String payInfo;
  List<String> memberRole = [];
  List<String> instrumentList = [];
  String instrument;
  String other;
  String otherTalent;
  String notes;
  String pay;
  bool isPrimary;
  String primaryContact;
  String emergencyContact;
  int status = 0;

  BandMember(
      {this.userId,
      this.otherTalent,
      this.permissions,
      this.payInfo,
      this.email,
      this.firstName,
      this.lastName,
      this.mobileText,
      this.memberRole,
      this.instrument,
      this.primaryContact,
      this.other,
      this.id,
      this.status,
      this.notes,
      this.emergencyContact,
      this.pay,
      this.instrumentList
      });

  BandMember.fromJSON(dynamic data) {
    id = data['id'];
    userId = data['user_id'];
    email = data['email'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    mobileText = data['mobileText'];
    primaryContact = data['primaryContact'];
    notes = data['notes'];
    pay = data['pay'];
    emergencyContact = data['emergencyContact'];
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
    if (data['instrumentList'] != null) {
      for (var item in data['instrumentList']) {
        instrumentList.add(item.toString());
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = userId;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileText'] = mobileText;
    data['otherTalent'] = otherTalent;
    data['emergencyContact'] = emergencyContact;
    data['primaryContact'] = primaryContact;
    data['pay'] = pay;
    data['status'] = status;
    data['notes'] = notes;
    data['permissions'] = permissions;
    data['payInfo'] = payInfo;
    data['memberRole'] = memberRole;
    data['instrument'] = instrument;
    data['other'] = other;
    data['instrumentList'] = instrumentList;
    return data;
  }
}
