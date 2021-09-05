import 'package:audioly/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider{
  static const String TABLE_FAVORITES = "favorites";
  static const String COLUMN_ID = "id";
  static const String COLUMN_SONGNAME = "title";
  static const String COLUMN_SONGARTIST = "artist";
  static const String COLUMN_DURATION = "duration";
  static const String COLUMN_FILEPATH = "filePath";

  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database? _database;

  Future<Database?> get database async {
    
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, "favoritesDB.db"), version: 2,
        onCreate: (Database database, int version) async {
      await database.execute(
        "CREATE TABLE $TABLE_FAVORITES($COLUMN_ID INTEGER PRIMARY KEY, $COLUMN_SONGNAME TEXT UNIQUE, $COLUMN_SONGARTIST TEXT, $COLUMN_DURATION TEXT, $COLUMN_FILEPATH TEXT)");
      }
    );
  }

  Future<List<Music>> getMusic() async{
    final db = await database;

    var musics = await db!.query(
      TABLE_FAVORITES,
      columns: [COLUMN_ID, COLUMN_SONGNAME, COLUMN_SONGARTIST, COLUMN_DURATION, COLUMN_FILEPATH],
    );

    List<Music> favoriteList = [];

    musics.forEach((currentMusic) { 
      Music music = Music.fromMap(currentMusic);
      favoriteList.add(music);
    });
    return favoriteList;
  }

  Future<Music> insert(Music music) async {
    final db = await database;
    music.id = await db!.insert(TABLE_FAVORITES, music.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return music;
  }

  Future<int>delete(int id) async {
    final db = await database;

    return await db!.delete(
      TABLE_FAVORITES,
      where: "id=?",
      whereArgs: [id]
    );
  }
}