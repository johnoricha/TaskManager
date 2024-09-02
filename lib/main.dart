import 'package:flutter/material.dart';
import 'package:task_manager/core/di/initializer.dart';
import 'package:task_manager/ui/tasks/tasks_screen.dart';

void main() {
  initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TasksScreen(title: 'Task Manager'),
    );
  }
}


