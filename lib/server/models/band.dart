import 'package:gigtrack/base/base_model.dart';

class Band extends BaseModel {
  String name;
  String legalName;
  String legalStructure;
  String dateStarted;
  String musicStyle;
  String responsbilities;
  String email;
  String website;

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
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['name'] = name;
    data['legal_name'] = legalName;
    data['legal_structure'] = legalStructure;
    data['date_started'] = dateStarted;
    data['music_style'] = musicStyle;
    data['responsbilities'] = responsbilities;
    data['email'] = email;
    data['website'] = website;
    return data;
  }
}
