import 'package:gigtrack/base/base_model.dart';

class UserPlayingStyle extends BaseModel {
  String id;
  String user_id;
  String band_id;
  String playing_styles;
  String instruments;


  UserPlayingStyle(
      {this.band_id, this.user_id, this.playing_styles, this.instruments});

  UserPlayingStyle.fromJSON(dynamic data) {
    id = data['id'];
    user_id = data['user_id'];
    band_id = data['band_id'];
    playing_styles = data['playing_styles_ids'];
    instruments = data['instruments_ids'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['user_id'] = user_id;
    data['band_id'] = band_id;
    data['playing_styles_ids'] = playing_styles;
    data['instruments_ids'] = instruments;
    return data;
  }
}
