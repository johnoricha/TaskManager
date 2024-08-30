// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) => TaskEntity(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      userId: (json['userId'] as num).toInt(),
      completed: TaskEntity._boolFromInt((json['completed'] as num).toInt()),
    );

Map<String, dynamic> _$TaskEntityToJson(TaskEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'userId': instance.userId,
      'completed': TaskEntity._boolToInt(instance.completed),
    };
