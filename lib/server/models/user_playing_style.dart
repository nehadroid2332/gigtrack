import 'package:gigtrack/base/base_model.dart';

class UserPlayingStyle extends BaseModel {
  String id;
  String user_id;
  List<String> playing_styles = [];
  Map<String, String> instruments = {};
  String role;
  String degree;
  String age;
  String year;
  String response;
  String education;
  String listSchool;
  String bandId;
  String about;
  String earn;
  List<String> experience = [];
  String otherExp;
  List<String> files = [];
  String viewerKnow;

  UserPlayingStyle(
      {this.user_id,
      this.id,
      this.playing_styles,
      this.instruments,
      this.role,
      this.degree,
      this.age,
      this.year,
      this.otherExp,
      this.education,
      this.listSchool,
      this.earn,
      this.about,
      this.experience,
      this.bandId,
      this.viewerKnow,
      this.files});

  UserPlayingStyle.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    if (data['playing_styles_ids'] != null) {
      for (var item in data['playing_styles_ids']) {
        playing_styles.add(item.toString());
      }
    }
    if (data['instruments_ids'] != null) {
      Map ins = data['instruments_ids'];
      for (var item in ins.keys) {
        instruments[item.toString()] = ins[item];
      }
    }
    if (data['files'] != null) {
      for (String item in data['files']) {
        files.add(item);
      }
    }
    otherExp = data['otherExp'];
    age = data['age'];
    year = data['year'];
    role = data['role'];
    about = data['about'];
    degree = data['degree'];
    education = data['education'];
    bandId = data['bandId'];
    listSchool = data['listSchool'];
    earn = data['earn'];
    viewerKnow = data['viewerKnow'];
    if (data['experience'] != null) {
      for (var item in data['experience']) {
        experience.add(item.toString());
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = user_id;
    data['otherExp'] = otherExp;
    data['playing_styles_ids'] = playing_styles;
    data['instruments_ids'] = instruments;
    data['role'] = role;
    data['about'] = about;
    data['bandId'] = bandId;
    data['degree'] = degree;
    data['education'] = education;
    data['listSchool'] = listSchool;
    data['earn'] = earn;
    data['age'] = age;
    data['year'] = year;
    data['viewerKnow'] = viewerKnow;
    data['experience'] = experience;
    data['files'] = files;
    return data;
  }
}
