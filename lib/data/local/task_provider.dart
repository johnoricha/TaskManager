import 'package:task_manager/data/local/models/task_entity.dart';

abstract class TaskProvider {

  Future<void> insertTask(TaskEntity task);

  Future<List<TaskEntity>> getTasks();

  Future<void> updateTask(TaskEntity task);

  Future<void> deleteTask(int taskId);
}