import 'package:flutter/material.dart';

import '../../data/activity/data.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({required this.onTap, required this.activity, super.key});

  final Function() onTap;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final isCompleted = false;
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
            activity.title,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            activity.duration,
            style: TextStyle(
              color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
