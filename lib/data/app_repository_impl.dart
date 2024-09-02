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
    print('appRepo: getTasks called.');

    final connected = await isConnected();

    // if (connected) {
    //   final result = await tasksRemoteRepository.getTasks();
    //
    //   if (result is Success) {
    //     print('result is success');
    //     final taskDtos = (result as Success).data as List<TaskDto>;
    //
    //     print('taskDtos: $taskDtos');
    //     for (TaskDto taskDto in taskDtos) {
    //       await taskProvider.insertTask(taskDto.toTaskEntity());
    //     }
    //
    //     final tasks = await taskProvider.getTasks();
    //
    //     print('taskEntities: $tasks');
    //
    //     return Success(data: tasks);
    //   }
    //
    //   print('appRepo: getTasks failed.: ${(result as Failure).errorMessage}');
    //
    //   return Failure(errorMessage: (result as Failure).errorMessage);
    // } else {
      final tasks = await taskProvider.getTasks();
      return Success(data: tasks);
    // }
  }

  @override
  Future<ApiResponse<List<TaskEntity>>> getBackedUpTasks() async {
    print('appRepo: getTasks called.');

    final connected = await isConnected();

      final result = await tasksRemoteRepository.getTasks();

      if (result is Success) {
        print('result is success');
        final taskDtos = (result as Success).data as List<TaskDto>;

        print('taskDtos: $taskDtos');
        for (TaskDto taskDto in taskDtos) {
          await taskProvider.insertTask(taskDto.toTaskEntity());
        }

        final tasks = await taskProvider.getTasks();

        print('taskEntities: $tasks');

        return Success(data: tasks);
      }

      print('appRepo: getTasks failed.: ${(result as Failure).errorMessage}');

      return Failure(errorMessage: (result as Failure).errorMessage);

  }

  @override
  Future<void> createTask(Task task) async {
    await taskProvider.insertTask(
        task.copyWith(syncStatus: SyncStatus.pendingCreate).toEntity());
  }

  @override
  Future<Task?> getTask(int id) async {
    final result = await tasksRemoteRepository.getTask(id);

    if (result is Success) {
      final taskDto = (result as Success).data as TaskDto;
      return taskDto.toTask();
    }

    return null;
  }

  @override
  Future<void> updateTask(Task task) async {
    return await taskProvider.updateTask(task.toEntity());
  }

  @override
  Future<void> deleteTask(int taskId) async {
    return await taskProvider.deleteTask(taskId);
  }

  @override
  Future<void> syncTasks() async {
    final tasks = await taskProvider.getTasks();

    final pendingTasks = tasks.where((e) => e.syncStatus != SyncStatus.synced);

    final connected = await isConnected();

    if (connected) {
      print('isConnected: $connected');
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
                await tasksRemoteRepository.deleteTask(pendingTask.id ?? 1);
            if (result is Success) {
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
      print('not connected');
    }
  }
}
