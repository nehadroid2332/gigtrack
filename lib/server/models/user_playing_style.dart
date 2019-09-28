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
  String earn;
  List<String> experience = [];
  String viewerKnow;

  UserPlayingStyle({
    this.user_id,
    this.playing_styles,
    this.instruments,
    this.role,
    this.degree,
    this.education,
    this.listSchool,
    this.earn,
    this.experience,
    this.viewerKnow,
  });

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

    role = data['role'];
    degree = data['degree'];
    education = data['education'];
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
    data['playing_styles_ids'] = playing_styles;
    data['instruments_ids'] = instruments;
    data['role'] = role;
    data['degree'] = degree;
    data['education'] = education;
    data['listSchool'] = listSchool;
    data['earn'] = earn;
    data['viewerKnow'] = viewerKnow;
    data['experience'] = experience;
    return data;
  }
}
