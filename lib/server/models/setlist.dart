import 'package:gigtrack/base/base_model.dart';

class SetList extends BaseModel {
  String setListName;
  List<Song> songs = [];
  String id;
  String user_id;
  SetList();

  SetList.fromJSON(dynamic data) {
    setListName = data['setListName'];
    id = data['id'];
    user_id = data['user_id'];
    if (data['songs'] != null) {
      for (var item in data['songs']) {
        Song song = Song.fromJSON(item);
        songs.add(song);
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['setListName'] = setListName;
    data['id'] = id;
    data['user_id'] = user_id;
    List<dynamic> sb = [];
    for (Song item in songs) {
      sb.add(item.toMap());
    }
    data['songs'] = sb;
    return data;
  }
}

class Song extends BaseModel {
  String name;
  String artist;
  String chords;
  String perform;
  String id;

  Song();

  Song.fromJSON(dynamic data) {
    id = data['id'];
    name = data['name'];
    artist = data['artist'];
    chords = data['chords'];
    perform = data['perform'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['name'] = name;
    data['artist'] = artist;
    data['chords'] = chords;
    data['perform'] = perform;
    return data;
  }
}
