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
  final String title;
  final int id;
  final int userId;
  final bool completed;
  final SyncStatus syncStatus;

  const Task({
    required this.title,
    required this.id,
    required this.completed,
    required this.userId,
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
        title: title ?? this.title,
        id: id ?? this.id,
        completed: completed ?? this.completed,
        userId: userId ?? this.userId,
        syncStatus: syncStatus ?? this.syncStatus,
      );

  TaskEntity toEntity() => TaskEntity(
        id: id,
        title: title,
        userId: userId,
        completed: completed,
        syncStatus: syncStatus,
      );

  @override
  List<Object?> get props => [title, id, userId, completed, syncStatus];
}
