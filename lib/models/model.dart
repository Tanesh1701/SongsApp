import 'package:audioly/db/database_provider.dart';

class Music {
  String? title;
  String? artist;
  String? duration;
  String? filePath;
  int? id;

  Music(this.title, this.artist, this.duration, this.filePath);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_SONGNAME: title,
      DatabaseProvider.COLUMN_SONGARTIST: artist,
      DatabaseProvider.COLUMN_DURATION: duration,
      DatabaseProvider.COLUMN_FILEPATH: filePath
    };

    if (id!=null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Music.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    title = map[DatabaseProvider.COLUMN_SONGNAME];
    artist = map[DatabaseProvider.COLUMN_SONGARTIST];
    duration = map[DatabaseProvider.COLUMN_DURATION];
    filePath = map[DatabaseProvider.COLUMN_FILEPATH];
  }

}