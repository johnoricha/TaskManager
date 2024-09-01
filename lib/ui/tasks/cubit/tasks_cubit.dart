import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final AppRepository appRepository;

  TasksCubit(this.appRepository) : super(const TasksState(tasks: []));

  Future<void> getTasks() async {
    final result = await appRepository.getTasks();

    if (result is Success) {
      print('result is success');
      final tasks = result.data as List<TaskEntity>;

      print('tasks: ${tasks.map((e) => e.toTask()).toList()}');

      emit(
        state.copyWith(
          tasks: tasks.map((e) => e.toTask()).toList(),
        ),
      );
    }
  }

  Future<void> updateTask(Task task) async {
    await appRepository
        .updateTask(task.copyWith(syncStatus: SyncStatus.pendingUpdate));
  }

  Future<void> deleteTask(Task task) async {
    await appRepository
        .updateTask(task.copyWith(syncStatus: SyncStatus.pendingDelete));
  }

  Future<void> createTask(Task task) async {
    await appRepository.createTask(task);
  }

  Future<void> syncTasks() async {
    await appRepository.syncTasks();
  }
}
