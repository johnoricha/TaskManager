import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/local/task_provider.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';
import 'package:task_manager/data/repository/tasks_repository.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class AppRepositoryImpl extends AppRepository {
  TaskProvider taskProvider;
  TasksRemoteRepository tasksRemoteRepository;

  AppRepositoryImpl(this.taskProvider, this.tasksRemoteRepository);

  Future<bool> isConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.first != ConnectivityResult.none;
  }

  @override
  Future<ApiResponse<List<TaskEntity>>> getTasks() async {
    final result = await taskProvider.getTasks();

    if (result is Success) {
      return Success(data: (result as Success).data);
    }
    return Failure(errorMessage: (result as Failure).errorMessage);
  }

  @override
  Future<ApiResponse<List<TaskEntity>>> getBackedUpTasks() async {

    final connected = await isConnected();

    if (connected) {
      final result = await tasksRemoteRepository.getTasks();

      if (result is Success) {
        final taskDtos = (result as Success).data as List<TaskDto>;
        for (TaskDto taskDto in taskDtos) {
          await taskProvider.insertTask(taskDto.toTaskEntity());
        }

        return taskProvider.getTasks();
      }
      return Failure(errorMessage: (result as Failure).errorMessage);
    } else {
      return Failure(errorMessage: 'No internet connection');
    }
  }

  @override
  Future<ApiResponse<void>> createTask(Task task) async {
    return taskProvider.insertTask(
        task.copyWith(syncStatus: SyncStatus.pendingCreate).toEntity());
  }

  @override
  Future<ApiResponse<void>> updateTask(Task task) async {
    return taskProvider.updateTask(task.toEntity());
  }

  @override
  Future<ApiResponse<void>> deleteTask(int taskId) async {
    return taskProvider.deleteTask(taskId);
  }

  @override
  Future<ApiResponse<void>> syncTasks() async {
    final result = await taskProvider.getTasks();

    if (result is Success) {
      final tasks = (result as Success).data;

      final pendingTasks =
          tasks.where((e) => e.syncStatus != SyncStatus.synced);

      final connected = await isConnected();

      if (connected) {
        for (final TaskEntity pendingTask in pendingTasks) {
          switch (pendingTask.syncStatus) {
            case SyncStatus.pendingCreate:
              final result = await tasksRemoteRepository.createTask(pendingTask
                  .copyWith(syncStatus: SyncStatus.synced)
                  .toTaskDto());

              if (result is Success) {
                await taskProvider.updateTask(
                    pendingTask.copyWith(syncStatus: SyncStatus.synced));
              }
              break;

            case SyncStatus.pendingDelete:
              final result =
                  await tasksRemoteRepository.getTask(pendingTask.id!);
              if (result is Success) {
                // task exists in remote DB, hence, delete (sync)
                final syncResult = await tasksRemoteRepository.deleteTask(
                    pendingTask.id!);

                if (syncResult is Success) {
                  await taskProvider.deleteTask(
                      pendingTask.id!);
                }
              } else if (result is Failure && (result as Failure).code == 404) {
                // task does not exist in remote DB, hence, delete it from local db
                  await taskProvider.deleteTask(pendingTask.id ?? 1);
              }
              break;

            case SyncStatus.pendingUpdate:
              final result =
                  await tasksRemoteRepository.getTask(pendingTask.id ?? 1);

              if (result is Success) {
                // task exists in remote DB, hence, update (sync)
                final syncResult = await tasksRemoteRepository.updateTask(
                    pendingTask
                        .copyWith(syncStatus: SyncStatus.synced)
                        .toTaskDto(),
                    pendingTask.id ?? 1);

                if (syncResult is Success) {
                  await taskProvider.updateTask(
                      pendingTask.copyWith(syncStatus: SyncStatus.synced));
                }
              } else if (result is Failure && (result as Failure).code == 404) {
                // task does not exist in remote DB, hence, create it
                print('task not found');
                final createResult = await tasksRemoteRepository.createTask(
                    pendingTask
                        .copyWith(syncStatus: SyncStatus.synced)
                        .toTaskDto());

                if (createResult is Success) {
                  await taskProvider.updateTask(
                      pendingTask.copyWith(syncStatus: SyncStatus.synced));
                }
              }
              break;

            default:
              break;
          }
        }
      } else {
        return Failure(errorMessage: 'Oops! no internet connection');
      }
      return Success(data: null);
    }

    return Failure(errorMessage: (result as Failure).errorMessage);
  }
}
