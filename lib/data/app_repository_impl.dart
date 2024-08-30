import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/local/task_provider.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';
import 'package:task_manager/data/repository/tasks_repository.dart';
import 'package:task_manager/ui/tasks_state.dart';

class AppRepositoryImpl extends AppRepository {
  TaskProvider taskProvider;
  TasksRepository tasksRepository;

  AppRepositoryImpl(this.taskProvider, this.tasksRepository);

  @override
  Future<ApiResponse<List<TaskEntity>>> getTasks() async {
    print('appRepo: getTasks called.');
    final result = await tasksRepository.getTasks();

    if (result is Success) {
      print('result is success');
      final taskDtos = (result as Success).data as List<TaskDto>;

      for (TaskDto taskDto in taskDtos) {
        await taskProvider.insertTask(taskDto.toTaskEntity());
      }

      final tasks = await taskProvider.getTasks();

      return Success(data: tasks);
    }

    print('appRepo: getTasks failed.');

    return Failure(errorMessage: (result as Failure).errorMessage);
  }

  @override
  Future<void> updateTask(Task task) {
    final updatedTask = task.copyWith(completed: false);

    return taskProvider.updateTask(updatedTask.toEntity());
  }

  @override
  Future<void> deleteTask(int taskId) {
    return taskProvider.deleteTask(taskId);
  }
}
