import 'package:gigtrack/base/base_model.dart';

class PlayingStyleResponse extends BaseModel {
  int status;
  List<PlayingStyle> pstyles = [];
  List<Instruments> instruments = [];
  List<UserPlayingStyle> user_playing_styles = [];

  PlayingStyleResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['pstyles'] != null) {
      for (var ps in data['pstyles']) {
        pstyles.add(PlayingStyle.fromJSON(ps));
      }
    }
    if (data['instruments'] != null) {
      for (var ps in data['instruments']) {
        instruments.add(Instruments.fromJSON(ps));
      }
    }
    if (data['user_playing_styles'] != null) {
      for (var ps in data['user_playing_styles']) {
        user_playing_styles.add(UserPlayingStyle.fromJSON(ps));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    List<dynamic> pss = [];
    for (PlayingStyle ps in pstyles) {
      pss.add(ps.toMap());
    }
    data['pstyles'] = pss;

    List<dynamic> ins = [];
    for (Instruments ps in instruments) {
      ins.add(ps.toMap());
    }
    data['instruments'] = pss;

    List<dynamic> upss = [];
    for (UserPlayingStyle ps in user_playing_styles) {
      upss.add(ps.toMap());
    }
    data['user_playing_styles'] = pss;

    return data;
  }
}

class PlayingStyle extends BaseModel {
  String id;
  String title;

  PlayingStyle.fromJSON(dynamic data) {
    id = data['id'];
    title = data['title'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Instruments extends BaseModel {
  String id;
  String title;

  Instruments.fromJSON(dynamic data) {
    id = data['id'];
    title = data['title'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class UserPlayingStyle extends BaseModel {
  String id;
  String user_id;
  String band_id;
  String playing_styles_ids;
  String instruments_ids;

  String playingStyle = "";
  String instrument = "";

  UserPlayingStyle.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    band_id = data['band_id'];
    playing_styles_ids = data['playing_styles_ids'];
    instruments_ids = data['instruments_ids'];
  }

  void setNames(List<PlayingStyle> pList, List<Instruments> iList) {
    List<String> pss = playing_styles_ids.split(",");
    for (PlayingStyle ps in pList) {
      for (String s in pss) {
        if (ps.id == s) {
          playingStyle += ps.title;
          break;
        }
      }
    }
    List<String> iss = instruments_ids.split(",");
    for (Instruments i in iList) {
      for (String ii in iss) {
        if (i.id == ii) {
          instrument += i.title;
          break;
        }
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = user_id;
    data['band_id'] = band_id;
    data['playing_styles_ids'] = playing_styles_ids;
    data['instruments_ids'] = instruments_ids;
    return data;
  }
}
