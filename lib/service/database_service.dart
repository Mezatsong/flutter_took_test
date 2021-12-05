import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseService {

  static late Database db;

  static initializeDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tooktest_db');
    db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE posts ( 
            _id INTEGER PRIMARY KEY AUTOINCREMENT, 
            content TEXT,
            image TEXT
          )
          '''
        );
      }
    );
  }

}
