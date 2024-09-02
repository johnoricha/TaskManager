import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/initializer.dart';
import 'package:task_manager/ui/add_edit_tasks/add_edit_task_screen.dart';
import 'package:task_manager/ui/components/task_item.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_cubit.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.title});

  final String title;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with WidgetsBindingObserver {
  int _selectedAmountIndex = 0;
  final _cubit = getIt.get<TasksCubit>();

  void initData() async {
    WidgetsBinding.instance.addObserver(this);
    await _cubit.syncTasks();
    await _cubit.getBackedUpTasks();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      bloc: _cubit,
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () async {
                  await _cubit.syncTasks();
                },
                icon: const Icon(Icons.sync))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: _selectedAmountIndex == 0
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.primaryFixed,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAmountIndex = 0;
                        });
                        _cubit.getTasks();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _selectedAmountIndex == 0
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                          ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: _selectedAmountIndex == 1
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.primaryFixed,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAmountIndex = 1;
                        });
                        _cubit.getTasks(taskFilter: TaskFilter.completed);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _selectedAmountIndex == 1
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                          ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: _selectedAmountIndex == 2
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.primaryFixed,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAmountIndex = 2;
                        });
                        _cubit.getTasks(taskFilter: TaskFilter.incomplete);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(
                          'Incomplete',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: _selectedAmountIndex == 2
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                          ),
                          // ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];

                      return TaskItem(
                        key: ValueKey(task.id),
                        task: task,
                        onItemClick: (task) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditTaskScreen(
                                isEditMode: true,
                                task: task,
                              ),
                            ),
                          );
                        },
                        onChecked: (task, checked) {
                          _cubit.updateTask(task.copyWith(completed: checked));
                        },
                      );
                    }),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddEditTaskScreen(isEditMode: false)));
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await _cubit.syncTasks();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
