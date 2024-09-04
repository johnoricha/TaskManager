import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/initializer.dart';
import 'package:task_manager/ui/cubit_status_state.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_cubit.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class AddEditTaskScreen extends StatefulWidget {
  const AddEditTaskScreen({super.key, this.task, required this.isEditMode});

  final Task? task;
  final bool isEditMode;

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController _taskNameTextEditingController;
  late TextEditingController _taskDescriptionTextEditingController;
  final TasksCubit _cubit = getIt.get<TasksCubit>();
  bool _isBtnEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state.createTaskStateStatus is SuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Task successfully added"),
          ));

          Navigator.pop(context);
        }

        if (state.updateTaskStateStatus is SuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Task updated"),
          ));
          Navigator.pop(context);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.isEditMode ? 'Edit Task' : 'Add Task'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
                    controller: _taskNameTextEditingController,
                    onChanged: (value) {
                      setState(() {
                        _isBtnEnabled =
                            _taskNameTextEditingController.text.isNotEmpty &&
                                _taskDescriptionTextEditingController
                                    .text.isNotEmpty;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 2,
                    decoration:
                        const InputDecoration(hintText: 'Enter task description', ),
                    controller: _taskDescriptionTextEditingController,
                    onChanged: (value) {
                      setState(() {
                        _isBtnEnabled =
                            _taskNameTextEditingController.text.isNotEmpty &&
                                _taskDescriptionTextEditingController
                                    .text.isNotEmpty;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FilledButton(
                      onPressed: _isBtnEnabled
                          ? () {
                              widget.isEditMode
                                  ? _cubit.updateTask(Task(
                                      id: widget.task?.id,
                                      name: _taskNameTextEditingController.text,
                                      description: _taskDescriptionTextEditingController.text,
                                      completed:
                                          widget.task?.completed ?? false))
                                  : _cubit.createTask(Task(
                                      name: _taskNameTextEditingController.text,
                                      description: _taskDescriptionTextEditingController.text,
                                      completed: false));
                            }
                          : null,
                      child:
                          Text(widget.isEditMode ? 'Update Task' : 'Add Task'))
                ]),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _taskNameTextEditingController =
        TextEditingController(text: widget.task?.name ?? '');
    _taskDescriptionTextEditingController =
        TextEditingController(text: widget.task?.description ?? '');

    super.initState();
  }

  @override
  void dispose() {
    _taskNameTextEditingController.dispose();
    _taskDescriptionTextEditingController.dispose();
    super.dispose();
  }
}
