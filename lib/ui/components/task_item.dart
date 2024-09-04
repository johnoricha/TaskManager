import 'package:animated_line_through/animated_line_through.dart';
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
  IconData _icon = Icons.keyboard_arrow_right;

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
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        onDismissed: (direction) {
          widget.onDismiss();
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: InkWell(
                    onTap: () {
                      setState(() {
                        if (_icon == Icons.keyboard_arrow_right) {
                          _icon = Icons.keyboard_arrow_down;
                        } else {
                          _icon = Icons.keyboard_arrow_right;
                        }
                      });
                    },
                    child: Icon(_icon)),
                title: AnimatedLineThrough(
                  isCrossed: _isCompleted,
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    widget.task.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                trailing: Checkbox(
                    value: _isCompleted,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    onChanged: (checked) {
                      setState(() {
                        _isCompleted = !_isCompleted;
                      });
                      widget.onChecked(widget.task, checked!);
                    }),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 56, right: 50),
                      height: _icon == Icons.keyboard_arrow_down ? 30 : 0,
                      child: Text(
                        widget.task.description,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    _icon == Icons.keyboard_arrow_down
                        ? const SizedBox(height: 16)
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
