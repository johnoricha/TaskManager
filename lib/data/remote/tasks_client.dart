import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';

part 'tasks_client.g.dart';

@RestApi(baseUrl: 'http://10.0.2.2:3001/taskmanager/api')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/tasks')
  Future<HttpResponse<List<TaskDto>>> getTasks();

  @POST('/tasks')
  Future<HttpResponse> createTask(@Body() TaskDto task);

  @PUT('/tasks/{id}')
  Future<HttpResponse> updateTask(@Body() TaskDto task, @Path() int id);

  @DELETE('/tasks/{id}')
  Future<HttpResponse> deleteTask(@Path() int id);
}