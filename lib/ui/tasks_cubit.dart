import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_entity.dart';
import 'package:task_manager/data/local/task_provider.dart';
import 'package:task_manager/data/remote/models/api_response.dart';
import 'package:task_manager/data/remote/models/task_dto.dart';
import 'package:task_manager/data/repository/tasks_repository.dart';
import 'package:task_manager/ui/tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  // final TasksRepository repo;
  // final TaskProvider dao;
  final AppRepository appRepository;

  TasksCubit(this.appRepository) : super(const TasksState(tasks: []));

  Future<void> getTasks() async {
    // final enitities = await dao.insertTask(
    //     const TaskEntity(id: 3, title: 'title 3', userId: 3, completed: true));

    final result = await appRepository.getTasks();

    if (result is Success) {
      print('result is success');
      final tasks = result.data as List<TaskEntity>;

      print('tasks: ${tasks.map((e) => e.toTask()).toList()}');

      emit(
        state.copyWith(
          tasks: tasks.map((e) => e.toTask()).toList(),
        ),
      );
    }
  }

  Future<void> updateTask() async {
    await appRepository.updateTask(
        const Task(id: 1, title: 'Title 1', completed: false, userId: 1));
  }

  Future<void> deleteTask() async {
    await appRepository.deleteTask(2);
  }
}
