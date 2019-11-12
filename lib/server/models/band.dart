import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/band_member.dart';

class Band extends BaseModel {
  String name;
  String legalName;
  String legalStructure;
  int dateStarted;
  String musicStyle;
  String email;
  String website;
  String contactInfo;
  String city;
  String state;
  String zip;
  String primaryContactEmail;
  String id;
  String userId;
  List<String> files = [];

  Map<String, BandMember> bandmates = Map();

  Band(
      {this.dateStarted,
      this.email,
      this.legalName,
      this.legalStructure,
      this.musicStyle,
      this.name,
      this.city,
      this.state,
      this.bandmates,
      this.zip,
      this.files,
      this.contactInfo,
      this.website});

  Band.fromJSON(dynamic data) {
    name = data['name'];
    legalName = data['legal_name'];
    legalStructure = data['legal_structure'];
    dateStarted = data['date_started'];
    musicStyle = data['music_style'];
    email = data['email'];
    website = data['website'];
    contactInfo = data['contactInfo'];
    city = data['city'];
    state = data['state'];
    zip = data['zip'];
    id = data['id'];
    primaryContactEmail = data['primaryContactEmail'];
    userId = data['user_id'];
    if (data['files'] != null) {
      for (String item in data['files']) {
        files.add(item);
      }
    }
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
    data['primaryContactEmail'] = primaryContactEmail;
    data['user_id'] = userId;
    data['email'] = email ?? "";
    data['contactInfo'] = contactInfo;
    data['website'] = website ?? "";
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['id'] = id;
    data['files'] = files;
    Map<String, dynamic> bnds = {};
    for (var key in bandmates.keys) {
      BandMember bandMember = bandmates[key];
      bnds[key] = bandMember.toMap();
    }
    data['bandmates'] = bnds;
    return data;
  }
}
