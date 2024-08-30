import 'package:sqflite/sqflite.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/local/task_manager_database.dart';
import 'package:task_manager/data/local/task_provider.dart';

class TaskProviderImpl extends TaskProvider {
  TaskMangerDatabase db;

  TaskProviderImpl(this.db);

  @override
  Future<void> insertTask(TaskEntity task) async {
    final database = await db.initDb();

    database.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    final database = await db.initDb();

    final taskEntities = await database.query('tasks');

    return [for (final task in taskEntities) TaskEntity.fromJson(task)];
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final database = await db.initDb();

    await database.update('tasks', task.toJson(), where: 'id = ?',
    whereArgs: [task.id]
    );
  }

  @override
  Future<void> deleteTask(int taskId) async {
    final database = await db.initDb();

    await database.delete('tasks', where: 'id = ?',
        whereArgs: [taskId]
    );  }
}
