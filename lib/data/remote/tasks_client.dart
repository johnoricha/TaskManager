import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';

part 'tasks_client.g.dart';

@RestApi(baseUrl: 'http://10.0.2.2:3001/taskmanager/api')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/tasks')
  Future<HttpResponse<List<TaskDto>>> getTasks();
}