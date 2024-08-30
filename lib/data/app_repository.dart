import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/ui/tasks_state.dart';

abstract class AppRepository {

  Future<ApiResponse<dynamic>> getTasks();

  Future<void> updateTask(Task task);

  Future<void> deleteTask(int taskId);

}