import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/tasks_state.dart';

part 'task_entity.g.dart';

@JsonSerializable()
class TaskEntity extends Equatable {
  final int id;
  final String name;
  final SyncStatus syncStatus;

  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  final bool completed;

  const TaskEntity({
    required this.id,
    required this.name,
    required this.completed,
    this.syncStatus = SyncStatus.notSynced,
  });

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TaskEntityToJson(this);

  Task toTask() => Task(
        id: id,
        name: name,
        completed: completed,
        syncStatus: syncStatus,
      );

  TaskDto toTaskDto() => TaskDto(
        id: id,
        name: name,
        completed: completed,
        syncStatus: syncStatus,
      );

  TaskEntity copyWith({
    int? id,
    String? title,
    bool? completed,
    int? userId,
    SyncStatus? syncStatus,
  }) =>
      TaskEntity(
          id: id ?? this.id,
          name: title ?? this.name,
          completed: completed ?? this.completed,
          syncStatus: syncStatus ?? this.syncStatus);

  @override
  List<Object?> get props => [id, name, completed, syncStatus];

  static bool _boolFromInt(int value) => value == 1;

  static int _boolToInt(bool value) => value ? 1 : 0;
}
