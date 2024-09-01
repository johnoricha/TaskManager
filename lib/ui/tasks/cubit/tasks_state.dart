import 'package:equatable/equatable.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/sync_status.dart';

class TasksState extends Equatable {
  final List<Task> tasks;

  const TasksState({required this.tasks});

  TasksState copyWith({List<Task>? tasks}) =>
      TasksState(tasks: tasks ?? this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class Task extends Equatable {
  final String name;
  final int? id;
  final bool completed;
  final SyncStatus syncStatus;

  const Task({
    required this.name,
    this.id,
    required this.completed,
    this.syncStatus = SyncStatus.notSynced,
  });

  Task copyWith({
    String? title,
    int? id,
    int? userId,
    bool? completed,
    SyncStatus? syncStatus,
  }) =>
      Task(
        name: title ?? this.name,
        id: id ?? this.id,
        completed: completed ?? this.completed,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  TaskEntity toEntity() => TaskEntity(
        id: id,
        name: name,
        completed: completed,
        syncStatus: syncStatus,
      );

  @override
  List<Object?> get props => [name, id, completed, syncStatus];
}
