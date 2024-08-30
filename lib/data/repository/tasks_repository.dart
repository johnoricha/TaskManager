import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';
import 'package:task_manager/data/remote/tasks_client.dart';

abstract class TasksRepository {
  Future<ApiResponse<List<TaskDto>>> getTasks();
}

class TasksRepositoryImpl extends TasksRepository {
  final RestClient restClient;

  TasksRepositoryImpl() : restClient = RestClient(Dio());

  @override
  Future<ApiResponse<List<TaskDto>>> getTasks() async {
    try {
      final response = await restClient.getTasks();

      if (response.response.statusCode! >= 200 &&
          response.response.statusCode! < 300) {
        // Process the response
        return Success(data: response.data);
      } else {
        return Failure(errorMessage: 'Failed to load data');
      }
    } on SocketException {
      return Failure(errorMessage: 'No internet connection');
    } on HttpException {
      return Failure(errorMessage: 'Failed to load data');
    } on FormatException {
      return Failure(errorMessage: 'Bad response format');
    } catch (e) {
      return Failure(errorMessage: 'An unexpected error occurred');
    }
  }
}
