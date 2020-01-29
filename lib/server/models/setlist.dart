import 'package:gigtrack/base/base_model.dart';

import '../../base/base_model.dart';

class SetList extends BaseModel {
  String setListName;
  List<Song> songs = [];
  String id;
  String user_id;
  String bandId;
  SetList();

  SetList.fromJSON(dynamic data) {
    setListName = data['setListName'];
    id = data['id'];
    bandId = data['bandId'];
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
    data['bandId'] = bandId;
    data['user_id'] = user_id;
    List<dynamic> sb = [];
    for (Song item in songs) {
      sb.add(item.toMap());
    }
    data['songs'] = sb;
    return data;
  }
}

class SongNotes extends BaseModel {
  String title;
  int time = 0;

  SongNotes({this.title, this.time});
  SongNotes.fromJSON(dynamic data) {
    title = data['title'];
    time = data['time'] ?? 0;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['title'] = title;
    data['time'] = time;
    return data;
  }
}

class Song extends BaseModel {
  String name;
  String artist;
  String chords;
  String perform;
  String id;
  String notes;
  int createdDate = DateTime.now().millisecondsSinceEpoch;
  List<SongNotes> subnotes = [];

  Song();

  Song.fromJSON(dynamic data) {
    id = data['id'];
    name = data['name'];
    artist = data['artist'];
    chords = data['chords'];
    perform = data['perform'];
    createdDate = data['createdDate'];
    notes = data['notes'];
    if (data['subnotes'] != null) {
      for (var item in data['subnotes']) {
        subnotes.add(SongNotes.fromJSON(item));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = super.toMap();
    data['id'] = id;
    data['name'] = name;
    data['artist'] = artist;
    data['createdDate'] = createdDate;
    data['chords'] = chords;
    data['perform'] = perform;
    data['notes'] = notes;
    List<dynamic> subnotess = [];
    for (var item in subnotes) {
      subnotess.add(item.toMap());
    }
    data['subnotes'] = subnotess;
    return data;
  }
}
