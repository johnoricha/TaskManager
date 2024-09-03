import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

abstract class AppRepository {

  Future<ApiResponse<dynamic>> createTask(Task task);

  Future<ApiResponse<dynamic>> getTasks();

  Future<ApiResponse<dynamic>> getBackedUpTasks();

  Future<ApiResponse<dynamic>> updateTask(Task task);

  Future<ApiResponse<dynamic>> deleteTask(int taskId);

  Future<ApiResponse<dynamic>> syncTasks();

}