import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/app_repository_impl.dart';
import 'package:task_manager/data/local/models/task_provider.dart';
import 'package:task_manager/data/local/task_manager_database.dart';
import 'package:task_manager/data/local/task_provider.dart';
import 'package:task_manager/data/repository/tasks_repository.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_cubit.dart';

final getIt = GetIt.instance;

void initialize() {

  //dio
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return dio;
  });

  //local db
  getIt.registerSingleton<TaskManagerDatabase>(TaskManagerDatabase());

  //repos
  getIt
      .registerLazySingleton<TaskProvider>(() => TaskProviderImpl(getIt.get()));
  getIt.registerLazySingleton<TasksRemoteRepository>(() => TasksRemoteRepositoryImpl());
  getIt.registerLazySingleton<AppRepository>(
      () => AppRepositoryImpl(getIt.get(), getIt.get()));

  //cubit
  getIt.registerLazySingleton<TasksCubit>(() => TasksCubit(getIt.get()));
}
