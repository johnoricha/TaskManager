
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/ui/tasks_state.dart';
part 'task_entity.g.dart';

@JsonSerializable()
class TaskEntity extends Equatable{
  final int id;
  final String title;
  final int userId;

  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  final bool completed;

  const TaskEntity({required this.id,
    required this.title,
    required this.userId,
    required this.completed});

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TaskEntityToJson(this);

  Task toTask() =>
      Task(
        id: id,
        userId: userId,
        title: title,
        completed: completed,
      );

  @override
  List<Object?> get props => [id, title, userId, completed];

  static bool _boolFromInt(int value) => value == 1;
  static int _boolToInt(bool value) => value ? 1 : 0;

}