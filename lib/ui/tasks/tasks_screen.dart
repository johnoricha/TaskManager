import 'package:flutter/material.dart';
import 'package:task_manager/core/di/initializer.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_cubit.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.title});

  final String title;

  @override
  State<TasksScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TasksScreen> {
  int _selectedAmountIndex = 0;
  final _cubit = getIt.get<TasksCubit>();

  void initData() async {
    await _cubit.getTasks();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}