import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/initializer.dart';
import 'package:task_manager/ui/add_edit_tasks/add_edit_task_screen.dart';
import 'package:task_manager/ui/components/task_item.dart';
import 'package:task_manager/ui/cubit_status_state.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_cubit.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.title});

  final String title;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with WidgetsBindingObserver {
  int _selectedCategoryIndex = 0;
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
      listener: (context, state) {
        if (state.syncTasksStateStatus is LoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Syncing Tasks..."),
          ));
        }

        if (state.syncTasksStateStatus is SuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Tasks synced!"),
          ));
        }

        if (state.syncTasksStateStatus is FailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(state.syncTaskErrorMsg ?? "Oops! Failed to sync tasks"),
          ));
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () async {
                  await _cubit.syncTasks();
                  await _cubit.getTasks();
                },
                icon: const Icon(Icons.sync))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            TaskFilter filter;

            switch (_selectedCategoryIndex) {
              case 1:
                filter = TaskFilter.completed;
                break;
              case 2:
                filter = TaskFilter.incomplete;
              default:
                filter = TaskFilter.all;
            }

            if (filter == TaskFilter.all) {
              await _cubit.getBackedUpTasks(taskFilter: filter);
            }
          },
          child: Center(
            child: buildListContainer(context, state),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddEditTaskScreen(isEditMode: false))).then((_) {
              _cubit.getTasks();
            });
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildListContainer(BuildContext context, TasksState state) {
    if (state.getTasksStateStatus is LoadingState) {
      return const CircularProgressIndicator();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: _selectedCategoryIndex == 0
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryFixed,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = 0;
                  });
                  _cubit.getTasks();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _selectedCategoryIndex == 0
                          ? Colors.white
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    // ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _selectedCategoryIndex == 1
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryFixed,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = 1;
                  });
                  _cubit.getTasks(taskFilter: TaskFilter.completed);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _selectedCategoryIndex == 1
                          ? Colors.white
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    // ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: _selectedCategoryIndex == 2
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryFixed,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = 2;
                  });
                  _cubit.getTasks(taskFilter: TaskFilter.incomplete);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Incomplete',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _selectedCategoryIndex == 2
                          ? Colors.white
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    // ),
                  ),
                ),
              ),
            ),
          ],
        ),
        buildListBody(state)
      ],
    );
  }

  Widget buildListBody(TasksState state) {
    if (state.tasks.isEmpty) {
      return const Expanded(child: Center(child: Text('No Task')));
    }

    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            final task = state.tasks[index];

            return Column(
              children: [
                TaskItem(
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
                    ).then((_) {
                      _cubit.getTasks();
                    });
                  },
                  onDismiss: () {
                    _cubit.deleteTask(task);
                  },
                  onChecked: (task, checked) {
                    _cubit.updateTask(task.copyWith(completed: checked));
                  },
                ),
                const Divider()
              ],
            );
          }),
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
