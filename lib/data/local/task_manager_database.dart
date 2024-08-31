import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskMangerDatabase {
  Future<Database> initDb() async {
    return openDatabase(join(await getDatabasesPath(), 'tasks_database.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, userId INTEGER, completed INTEGER, syncStatus TEXT)');
    }, version: 1);
  }
}
