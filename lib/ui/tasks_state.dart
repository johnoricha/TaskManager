import 'package:equatable/equatable.dart';
import 'package:task_manager/data/local/models/task_entity.dart';

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

  const Task(
      {required this.title,
      required this.id,
      required this.completed,
      required this.userId});

  Task copyWith({String? title, int? id, int? userId, bool? completed}) => Task(
      title: title ?? this.title,
      id: id ?? this.id,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId);

  TaskEntity toEntity() =>
      TaskEntity(id: id, title: title, userId: userId, completed: completed);

  @override
  List<Object?> get props => [title, id, userId, completed];
}
