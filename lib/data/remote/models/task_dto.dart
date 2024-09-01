import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/sync_status.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto extends Equatable {
  final int? id;
  final String name;
  final bool completed;
  final SyncStatus syncStatus;

  const TaskDto({
    this.id,
    required this.name,
    required this.completed,
    this.syncStatus = SyncStatus.notSynced,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);

  Task toTask() => Task(
        id: id,
        name: name,
        completed: completed,
        syncStatus: syncStatus,
      );

  TaskEntity toTaskEntity() => TaskEntity(
      id: id, name: name, completed: completed, syncStatus: syncStatus);

  @override
  List<Object?> get props => [id, name, completed, syncStatus];
}
