import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/cubit_status_state.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_cubit.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class AppRepositoryMock extends Mock implements AppRepository {}

class TaskFake extends Fake implements Task {}

void main() {
  setUpAll(() {
    registerFallbackValue(TaskFake());
  });

  group('Task Cubit Tests', () {
    late AppRepositoryMock appRepositoryMock;
    late TasksCubit tasksCubit;
    const expectedTasks = [
      Task(id: 1, name: 'Task 1', completed: false),
      Task(id: 2, name: 'Task 2', completed: false),
    ];
    const updatedTask = Task(id: 1, name: 'Task 1 updated', completed: true);

    setUp(() {
      appRepositoryMock = AppRepositoryMock();
      tasksCubit = TasksCubit(appRepositoryMock);
    });

    blocTest(
      'should return a list of tasks',
      build: () {
        when(() => appRepositoryMock.getTasks()).thenAnswer((answer) async {
          return Success(data: [
            const TaskEntity(id: 1, name: 'Task 1', completed: false),
            const TaskEntity(id: 2, name: 'Task 2', completed: false),
          ]);
        });
        return tasksCubit;
      },
      act: (cubit) => cubit.getTasks(),
      expect: () => [
        TasksState(tasks: const [], getTasksStateStatus: LoadingState()),
        TasksState(tasks: expectedTasks, getTasksStateStatus: SuccessState())
      ],
    );

    blocTest(
      'should update a task successfully',
      build: () {
        when(() => appRepositoryMock.updateTask(any()))
            .thenAnswer((_) async => Success(data: null));
        when(() => appRepositoryMock.getTasks()).thenAnswer((_) async {
          return Success(data: [
            const TaskEntity(id: 1, name: 'Task 1 updated', completed: true),
            const TaskEntity(id: 2, name: 'Task 2', completed: false),
          ]);
        });

        return tasksCubit;
      },
      act: (cubit) async {
        await cubit.updateTask(updatedTask);
        await cubit.getTasks();
      },
      expect: () => [
        TasksState(tasks: const [], updateTaskStateStatus: LoadingState()),
        TasksState(tasks: const [], updateTaskStateStatus: SuccessState()),
        TasksState(tasks: const [], getTasksStateStatus: LoadingState()),
        TasksState(
            tasks: [updatedTask, expectedTasks[1]],
            getTasksStateStatus: SuccessState())
      ],
    );

    blocTest(
      'should sync tasks successfully',
      build: () {
        when(() => appRepositoryMock.syncTasks()).thenAnswer((_) async {
          return Success(data: null);
        });

        when(() => appRepositoryMock.createTask(any())).thenAnswer((_) async {
          return Success(data: null);
        });

        when(() => appRepositoryMock.getTasks()).thenAnswer((_) async {
          return Success(data: [
            const TaskEntity(
                id: 3,
                name: 'Task 3',
                completed: false,
                syncStatus: SyncStatus.synced)
          ]);
        });

        return tasksCubit;
      },
      act: (cubit) async {
        await cubit
            .createTask(const Task(id: 3, name: 'Task 3', completed: false));
        await cubit.syncTasks();
        await cubit.getTasks();
      },
      expect: () => [
        TasksState(tasks: const [], createTaskStateStatus: LoadingState()),
        TasksState(tasks: const [], createTaskStateStatus: SuccessState()),
        TasksState(tasks: const [], syncTasksStateStatus: LoadingState()),
        TasksState(tasks: const [], syncTasksStateStatus: SuccessState()),
        TasksState(tasks: const [], getTasksStateStatus: LoadingState()),
        TasksState(tasks: const [
          Task(
              id: 3,
              name: 'Task 3',
              completed: false,
              syncStatus: SyncStatus.synced)
        ], getTasksStateStatus: SuccessState()),
      ],
    );

    blocTest(
      'should delete a task successfully',
      build: () {
        when(() => appRepositoryMock.createTask(any())).thenAnswer((_) async {
          return Success(data: null);
        });
        when(() => appRepositoryMock.updateTask(any())).thenAnswer((_) async {
          return Success(data: null);
        });
        when(() => appRepositoryMock.getTasks()).thenAnswer((_) async {
          return Success(data: <TaskEntity>[]);
        });

        return tasksCubit;
      },
      act: (cubit) async {
        await cubit.createTask(
          const Task(id: 1, name: 'Task 1', completed: false),
        );
        await cubit.deleteTask(
          const Task(id: 1, name: 'Task 1', completed: false),
        );
        await cubit.getTasks();
      },
      expect: () => [
        TasksState(tasks: const [], createTaskStateStatus: LoadingState()),
        TasksState(tasks: const [], createTaskStateStatus: SuccessState()),
        TasksState(tasks: const [], deleteTaskStateStatus: SuccessState()),
        TasksState(tasks: const [], getTasksStateStatus: LoadingState()),
        TasksState(tasks: const [], getTasksStateStatus: SuccessState()),
      ],
    );

    blocTest(
      'should fetch backed-up tasks successfully when local tasks are empty',
      build: () {
        when(() => appRepositoryMock.getTasks()).thenAnswer((_) async {
          return Success(data: <TaskEntity>[]);
        });
        when(() => appRepositoryMock.getBackedUpTasks()).thenAnswer((_) async {
          return Success(data: [
            const TaskEntity(id: 3, name: 'Task 3', completed: false),
          ]);
        });

        return tasksCubit;
      },
      act: (cubit) => cubit.getBackedUpTasks(),
      expect: () => [
        TasksState(tasks: const [], getTasksStateStatus: LoadingState()),
        TasksState(
          tasks: const [Task(id: 3, name: 'Task 3', completed: false)],
          getTasksStateStatus: SuccessState(),
        ),
      ],
    );
  });
}
