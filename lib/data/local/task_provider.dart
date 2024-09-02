import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/remote/models/api_response.dart';

abstract class TaskProvider {

  Future<ApiResponse<void>> insertTask(TaskEntity task);

  Future<ApiResponse<List<TaskEntity>>> getTasks();

  Future<ApiResponse<void>> updateTask(TaskEntity task);

  Future<ApiResponse<void>> deleteTask(int taskId);
}