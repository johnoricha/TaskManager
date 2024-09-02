import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

abstract class AppRepository {

  Future<ApiResponse<void>> createTask(Task task);

  Future<ApiResponse<dynamic>> getTasks();

  Future<ApiResponse<dynamic>> getBackedUpTasks();

  Future<ApiResponse<void>> updateTask(Task task);

  Future<ApiResponse<void>> deleteTask(int taskId);

  Future<ApiResponse<void>> syncTasks();

}