import 'package:gigtrack/base/base_model.dart';
import 'package:gigtrack/server/models/user.dart';

class Band extends BaseModel {
  String name;
  String legalName;
  String legalStructure;
  String dateStarted;
  String musicStyle;
  String responsbilities;
  String email;
  String website;

  String id;
  String userId;

  List<User> bandMember = [];

  Band(
      {this.dateStarted,
      this.email,
      this.legalName,
      this.legalStructure,
      this.musicStyle,
      this.name,
      this.responsbilities,
      this.website});

  Band.fromJSON(dynamic data) {
    name = data['name'];
    legalName = data['legal_name'];
    legalStructure = data['legal_structure'];
    dateStarted = data['date_started'];
    musicStyle = data['music_style'];
    responsbilities = data['responsbilities'];
    email = data['email'];
    website = data['website'];
    id = data['id'];
    userId = data['user_id'];
    if (data['bandmates'] != null) {
      for (var bm in data['bandmates']) {
        for (var b in bm) {
          bandMember.add(User.fromJSON(b));
        }
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
    data['responsbilities'] = responsbilities ?? "";
    data['email'] = email ?? "";
    data['website'] = website ?? "";

    List<dynamic> bm = [];
    for (var b in bandMember) {
      bm.add(b.toMap());
    }
    data['bandmates'] = bm;
    return data;
  }
}
