// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      userId: (json['userId'] as num).toInt(),
      completed: json['completed'] as bool,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.notSynced,
    );

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'userId': instance.userId,
      'completed': instance.completed,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingCreate: 'pendingCreate',
  SyncStatus.pendingUpdate: 'pendingUpdate',
  SyncStatus.pendingDelete: 'pendingDelete',
  SyncStatus.notSynced: 'notSynced',
};
