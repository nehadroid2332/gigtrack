import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/user.dart';

class Band extends BaseModel {
  String name;
  String legalName;
  String legalStructure;
  int dateStarted;
  String musicStyle;
  String email;
  String website;

  String id;
  String userId;

  Map<String, BandMember> bandmates = Map();

  Band(
      {this.dateStarted,
      this.email,
      this.legalName,
      this.legalStructure,
      this.musicStyle,
      this.name,
      this.website});

  Band.fromJSON(dynamic data) {
    name = data['name'];
    legalName = data['legal_name'];
    legalStructure = data['legal_structure'];
    dateStarted = data['date_started'];
    musicStyle = data['music_style'];
    email = data['email'];
    website = data['website'];
    id = data['id'];
    userId = data['user_id'];
    if (data['bandmates'] != null) {
      bandmates.clear();
      Map map = data['bandmates'];
      for (MapEntry item in map.entries) {
        bandmates[item.key] = BandMember.fromJSON(item.value);
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['name'] = name ?? "";
    data['legal_name'] = legalName ?? "";
    data['legal_structure'] = legalStructure ?? "";
    data['date_started'] = dateStarted ?? "";
    data['music_style'] = musicStyle ?? "";
    data['user_id'] = userId;
    data['email'] = email ?? "";
    data['website'] = website ?? "";
    data['id'] = id;
    Map<String, dynamic> bnds = {};
    for (var key in bandmates.keys) {
      BandMember bandMember = bandmates[key];
      bnds[key] = bandMember.toMap();
    }
    data['bandmates'] = bnds;
    return data;
  }
}
