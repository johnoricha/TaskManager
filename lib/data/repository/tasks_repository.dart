import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_manager/core/di/initializer.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';
import 'package:task_manager/data/remote/tasks_client.dart';

abstract class TasksRemoteRepository {
  Future<ApiResponse<List<TaskDto>>> getTasks();

  Future<ApiResponse<TaskDto?>> getTask(int id);

  Future<ApiResponse<void>> createTask(TaskDto task);

  Future<ApiResponse<void>> updateTask(TaskDto task, int id);

  Future<ApiResponse<void>> deleteTask(int id);
}

class TasksRemoteRepositoryImpl extends TasksRemoteRepository {
  final RestClient restClient;

  TasksRemoteRepositoryImpl()
      : restClient = RestClient(getIt.get<Dio>(),
            baseUrl: Platform.isAndroid
                ? 'http://10.0.2.2:3001/taskmanager/api'
                : 'http://localhost:3001/taskmanager/api');

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

  @override
  Future<ApiResponse<TaskDto?>> getTask(int id) async {
    try {
      final response = await restClient.getTask(id);

      if (response.response.statusCode! >= 200 &&
          response.response.statusCode! < 300) {
        // Process the response
        return Success(data: response.data);
      } else {
        return Failure(errorMessage: 'Failed to load data');
      }
    } on DioException catch (e) {
      return Failure(errorMessage: 'not found', code: e.response?.statusCode);
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

  @override
  Future<ApiResponse<dynamic>> createTask(TaskDto task) async {
    try {
      final response = await restClient.createTask(task);

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

  @override
  Future<ApiResponse<dynamic>> updateTask(TaskDto task, int id) async {
    try {
      final response = await restClient.updateTask(task, id);

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

  @override
  Future<ApiResponse<dynamic>> deleteTask(int id) async {
    try {
      final response = await restClient.deleteTask(id);

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
