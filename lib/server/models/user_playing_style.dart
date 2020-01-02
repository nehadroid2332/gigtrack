import 'package:gigtrack/base/base_model.dart';

import '../../base/base_model.dart';

class UserPlayingStyle extends BaseModel {
  String id;
  String user_id;
  List<String> playing_styles = [];
  Map<String, String> instruments = {};
  List<BandDetails> bandDetails = [];
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
  List<String> aboutTheBands = [];
  String otherExp;
  List<String> files = [];
  String viewerKnow;
  String aboutBand;
  String bandName;
  String bandEmail;
  String bandWebsite;
  String bandContacts;

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
      this.files,
      this.aboutBand,
      this.bandDetails,
      this.bandContacts,
      this.bandEmail,
      this.aboutTheBands,
      this.bandName,
      this.bandWebsite,
      this.response});

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
    aboutBand = data['aboutBand'];
    bandName = data['bandName'];
    bandEmail = data['bandEmail'];
    bandWebsite = data['bandWebsite'];
    bandContacts = data['bandContacts'];
    response = data['responsetext'];
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
    if (data['aboutTheBands'] != null) {
      for (var item in data['aboutTheBands']) {
        aboutTheBands.add(item.toString());
      }
    }
    if (data['bandDetails'] != null) {
      for (var item in data['bandDetails']) {
        bandDetails.add(BandDetails.fromJSON(item));
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
    data['aboutTheBands'] = aboutTheBands;
    data['files'] = files;
    data['aboutBand'] = aboutBand;
    data['bandName'] = bandName;
    data['bandEmail'] = bandEmail;
    data['bandWebsite'] = bandWebsite;
    data['bandContacts'] = bandContacts;
    data['responsetext'] = response;
    List<dynamic> items = [];
    if (bandDetails != null) {
      for (var item in bandDetails) {
        items.add(item.toMap());
      }
    }
    data['bandDetails'] = items;
    return data;
  }
}

class BandDetails extends BaseModel {
  String bandName;
  String desc;
  String dateFrom;
  String dateTo;
  String id;

  BandDetails({this.bandName, this.dateFrom, this.dateTo, this.desc, this.id});

  BandDetails.fromJSON(dynamic data) {
    bandName = data['bandName'];
    desc = data['desc'];
    dateFrom = data['dateFrom'];
    dateTo = data['dateTo'];
    id = data['id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map();
    data['bandName'] = bandName;
    data['desc'] = desc;
    data['dateFrom'] = dateFrom;
    data['dateTo'] = dateTo;
    data['id'] = id;
    return data;
  }
}
