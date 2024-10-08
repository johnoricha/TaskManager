import 'package:equatable/equatable.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/cubit_status_state.dart';

class TasksState extends Equatable {
  final List<Task> tasks;
  final String? getBackUpTaskErrorMsg;
  final String? syncTaskErrorMsg;
  final StateStatus? getTasksStateStatus;
  final StateStatus? updateTaskStateStatus;
  final StateStatus? deleteTaskStateStatus;
  final StateStatus? createTaskStateStatus;
  final StateStatus? syncTasksStateStatus;

  const TasksState({
    required this.tasks,
    this.getBackUpTaskErrorMsg,
    this.syncTaskErrorMsg,
    this.getTasksStateStatus = const InitialState(),
    this.updateTaskStateStatus = const InitialState(),
    this.deleteTaskStateStatus = const InitialState(),
    this.createTaskStateStatus = const InitialState(),
    this.syncTasksStateStatus = const InitialState(),
  });

  TasksState copyWith({
    List<Task>? tasks,
    StateStatus? getTasksStateStatus,
    StateStatus? updateTaskStateStatus,
    StateStatus? deleteTaskStateStatus,
    StateStatus? createTaskStateStatus,
    StateStatus? syncTasksStateStatus,
    String? getBackUpTaskErrorMsg,
    String? syncTaskErrorMsg,
  }) =>
      TasksState(
        tasks: tasks ?? this.tasks,
        getBackUpTaskErrorMsg:
            getBackUpTaskErrorMsg ?? this.getBackUpTaskErrorMsg,
        syncTaskErrorMsg: syncTaskErrorMsg ?? this.syncTaskErrorMsg,
        getTasksStateStatus: getTasksStateStatus ?? const InitialState(),
        updateTaskStateStatus: updateTaskStateStatus ?? const InitialState(),
        deleteTaskStateStatus: deleteTaskStateStatus ?? const InitialState(),
        createTaskStateStatus: createTaskStateStatus ?? const InitialState(),
        syncTasksStateStatus: syncTasksStateStatus ?? const InitialState(),
      );

  @override
  List<Object?> get props => [
        tasks,
        getBackUpTaskErrorMsg,
        syncTaskErrorMsg,
        getTasksStateStatus,
        updateTaskStateStatus,
        deleteTaskStateStatus,
        createTaskStateStatus,
        syncTasksStateStatus,
      ];
}

class Task extends Equatable {
  final String name;
  final String description;
  final int? id;
  final bool completed;
  final SyncStatus syncStatus;

  const Task({
    required this.name,
    required this.description,
    this.id,
    required this.completed,
    this.syncStatus = SyncStatus.notSynced,
  });

  Task copyWith({
    String? name,
    String? description,
    int? id,
    int? userId,
    bool? completed,
    SyncStatus? syncStatus,
  }) =>
      Task(
        name: name ?? this.name,
        description: description ?? this.description,
        id: id ?? this.id,
        completed: completed ?? this.completed,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  TaskEntity toEntity() => TaskEntity(
        id: id,
        description: description,
        name: name,
        completed: completed,
        syncStatus: syncStatus,
      );

  @override
  List<Object?> get props => [name, description, id, completed, syncStatus];
}
