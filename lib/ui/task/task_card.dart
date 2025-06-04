import 'package:flutter/material.dart';

import '../../data/task/data.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({required this.onTap, required this.task, super.key});

  final Function() onTap;
  final UserTask task;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.isCompleted ?? false;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.shade50 : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.access_time,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            '${(task.duration.millisecondsSinceEpoch * 0.001 / 60).floor()} minutes',
            style: TextStyle(
              color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
