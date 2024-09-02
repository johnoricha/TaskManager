import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/cubit_status_state.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final AppRepository appRepository;

  TasksCubit(this.appRepository) : super(const TasksState(tasks: []));

  Future<void> getTasks({TaskFilter taskFilter = TaskFilter.all}) async {
    emit(state.copyWith(getTasksStateStatus: LoadingState()));

    final result = await appRepository.getTasks();

    if (result is Success) {
      final tasks = result.data as List<TaskEntity>;

      var filteredTasks =
          tasks.where((task) => task.syncStatus != SyncStatus.pendingDelete);

      switch (taskFilter) {
        case TaskFilter.incomplete:
          filteredTasks = tasks
              .where((task) =>
                  task.completed == false &&
                  task.syncStatus != SyncStatus.pendingDelete)
              .toList();
          break;
        case TaskFilter.completed:
          filteredTasks = tasks
              .where((task) =>
                  task.completed == true &&
                  task.syncStatus != SyncStatus.pendingDelete)
              .toList();
          break;
        default:
      }

      emit(
        state.copyWith(
            tasks: filteredTasks.map((e) => e.toTask()).toList(),
            getTasksStateStatus: SuccessState()),
      );
    }
  }

  Future<void> getBackedUpTasks(
      {TaskFilter taskFilter = TaskFilter.all}) async {
    emit(state.copyWith(getTasksStateStatus: LoadingState()));

    final offlineTasksResult = await appRepository.getTasks();

    if (offlineTasksResult is Success) {
      final tasks = offlineTasksResult.data as List<TaskEntity>;
      if (tasks.isEmpty) {
        //get from remote server
        final result = await appRepository.getBackedUpTasks();

        if (result is Success) {
          final tasks = result.data as List<TaskEntity>;
          emit(
            state.copyWith(
              tasks: tasks.map((e) => e.toTask()).toList(),
              getTasksStateStatus: SuccessState(),
            ),
          );
        } else {
          emit(
            state.copyWith(
                getTasksStateStatus: FailedState(),
                getBackUpTaskErrorMsg: (result as Failure).errorMessage),
          );
        }
      } else {
        //get tasks from local db
        final result = await appRepository.getTasks();

        if (result is Success) {
          final tasks = result.data as List<TaskEntity>;
          emit(state.copyWith(
              tasks: tasks.map((task) => task.toTask()).toList()));
        }
      }
    }
  }

  Future<void> updateTask(Task task) async {
    emit(state.copyWith(updateTaskStateStatus: LoadingState()));
    final result = await appRepository
        .updateTask(task.copyWith(syncStatus: SyncStatus.pendingUpdate));
    if (result is Success) {
      emit(state.copyWith(updateTaskStateStatus: SuccessState()));
    } else {
      emit(state.copyWith(updateTaskStateStatus: FailedState()));
    }
  }

  Future<void> deleteTask(Task task) async {
    final result = await appRepository
        .updateTask(task.copyWith(syncStatus: SyncStatus.pendingDelete));

    if (result is Success) {
      final tasks = state.tasks.where((e) => e != task).toList();
      emit(state.copyWith(tasks: tasks, deleteTaskStateStatus: SuccessState()));
    } else {
      emit(state.copyWith(deleteTaskStateStatus: SuccessState()));
    }
  }

  Future<void> createTask(Task task) async {
    emit(state.copyWith(createTaskStateStatus: LoadingState()));
    final result = await appRepository.createTask(task);
    if (result is Success) {
      emit(state.copyWith(createTaskStateStatus: SuccessState()));
    } else {
      emit(state.copyWith(createTaskStateStatus: FailedState()));
    }
  }

  Future<void> syncTasks() async {
    emit(state.copyWith(syncTasksStateStatus: LoadingState()));
    final result = await appRepository.syncTasks();

    if (result is Success) {
      emit(state.copyWith(syncTasksStateStatus: SuccessState()));
    } else {
      emit(state.copyWith(
          syncTasksStateStatus: FailedState(),
          getSyncTaskErrorMsg: (result as Failure).errorMessage));
    }
  }
}

enum TaskFilter {
  all,
  completed,
  incomplete,
}
