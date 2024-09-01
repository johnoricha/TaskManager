import 'package:flutter/material.dart';
import 'package:task_manager/core/initializer.dart';
import 'package:task_manager/data/app_repository.dart';
import 'package:task_manager/data/local/models/task_provider.dart';
import 'package:task_manager/data/local/task_manager_database.dart';
import 'package:task_manager/data/local/task_provider.dart';
import 'package:task_manager/data/app_repository_impl.dart';
import 'package:task_manager/data/repository/tasks_repository.dart';
import 'package:task_manager/ui/tasks_cubit.dart';
import 'package:task_manager/ui/tasks_state.dart';

void main() {
  initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedAmountIndex = 0;
  final _cubit = getIt.get<TasksCubit>();

  void initData() async {
    await _cubit.getTasks();
    await _cubit.createTask(
        const Task(id: 3, title: 'title 3', completed: false, userId: 3));
    await _cubit.updateTask(
        const Task(id: 3, title: 'title 3', completed: false, userId: 3));
    await _cubit.deleteTask(
        const Task(id: 3, title: 'title 3', completed: true, userId: 3));
  }

  @override
  void initState() {
    print('initState!');
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
