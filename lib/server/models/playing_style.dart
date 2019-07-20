import 'package:gigtrack/base/base_model.dart';

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

class PlayingStyleResponse extends BaseModel {
  int status;
  List<PlayingStyle> pstyles = [];

  PlayingStyleResponse.fromJSON(dynamic data) {
    status = data['status'];
    if (data['pstyles'] != null) {
      for (var pS in data['pstyles']) {
        pstyles.add(PlayingStyle.fromJSON(pS));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['status'] = status;
    List<dynamic> pStyles = [];
    for (PlayingStyle ps in pstyles) {
      pStyles.add(ps.toMap());
    }
    data['pstyles'] = pStyles;
    return data;
  }
}
