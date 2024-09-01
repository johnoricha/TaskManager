// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) => TaskEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      completed: TaskEntity._boolFromInt((json['completed'] as num).toInt()),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.notSynced,
    );

Map<String, dynamic> _$TaskEntityToJson(TaskEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'completed': TaskEntity._boolToInt(instance.completed),
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingCreate: 'pendingCreate',
  SyncStatus.pendingUpdate: 'pendingUpdate',
  SyncStatus.pendingDelete: 'pendingDelete',
  SyncStatus.notSynced: 'notSynced',
};
