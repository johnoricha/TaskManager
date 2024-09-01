import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskManagerDatabase {
  Future<Database> initDb() async {
    return openDatabase(join(await getDatabasesPath(), 'tasks_database.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, name TEXT, completed INTEGER, syncStatus TEXT)');
    }, version: 1);
  }
}
