import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/local/task_manager_database.dart';
import 'package:task_manager/data/local/task_provider.dart';
import 'package:task_manager/data/remote/models/api_response.dart';

class TaskProviderImpl extends TaskProvider {
  TaskManagerDatabase db;

  TaskProviderImpl(this.db);

  @override
  Future<ApiResponse<void>> insertTask(TaskEntity task) async {
    try {
      final database = await db.initDb();

      database.insert(
        'tasks',
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return Success(data: null);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Failure(errorMessage: 'failed to insert task');
    }
  }

  @override
  Future<ApiResponse<List<TaskEntity>>> getTasks() async {
    try {
      final database = await db.initDb();

      final taskEntities = await database.query('tasks');

      final resultData = [
        for (final task in taskEntities) TaskEntity.fromJson(task)
      ];

      return Success(data: resultData);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Failure(errorMessage: 'failed to get taskss');
    }
  }

  @override
  Future<ApiResponse<void>> updateTask(TaskEntity task) async {
    try {
      final database = await db.initDb();

      await database.update('tasks', task.toJson(),
          where: 'id = ?', whereArgs: [task.id]);

      return Success(data: null);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Failure(errorMessage: 'failed to update task');
    }
  }

  @override
  Future<ApiResponse<void>> deleteTask(int taskId) async {
    try {
      final database = await db.initDb();

      await database.delete('tasks', where: 'id = ?', whereArgs: [taskId]);

      return Success(data: null);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Failure(errorMessage: 'failed to delete task');
    }
  }
}
