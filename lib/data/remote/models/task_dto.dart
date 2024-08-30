import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/ui/tasks_state.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto extends Equatable {
  final int id;
  final String title;
  final int userId;
  final bool completed;

  const TaskDto(
      {required this.id,
      required this.title,
      required this.userId,
      required this.completed});

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Task toTask() => Task(
        id: id,
        userId: userId,
        title: title,
        completed: completed,
      );

  TaskEntity toTaskEntity() =>
      TaskEntity(id: id, userId: userId, title: title, completed: completed);

  @override
  List<Object?> get props => [id, title, userId, completed];
}
