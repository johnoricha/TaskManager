import 'package:flutter/material.dart';
import 'package:task_manager/ui/tasks/cubit/tasks_state.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onItemClick,
    required this.onChecked,
    required this.onDismiss,
  });

  final Task task;
  final Function(Task task) onItemClick;
  final Function(Task task, bool checked) onChecked;
  final VoidCallback onDismiss;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool _isCompleted = false;

  @override
  void initState() {
    _isCompleted = widget.task.completed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onItemClick(widget.task);
      },
      child: Dismissible(
        key: ValueKey(widget.task.id.toString()),
        background: Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          widget.onDismiss();
        },
        child: Material(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.task.name,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Checkbox(
                      value: _isCompleted,
                      onChanged: (checked) {
                        setState(() {
                          _isCompleted = !_isCompleted;
                        });
                        widget.onChecked(widget.task, checked!);
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
