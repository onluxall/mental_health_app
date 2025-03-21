import 'package:flutter/cupertino.dart';

import '../data/mental_health_category.dart';

class TasksScreen extends StatefulWidget {
  final List<MentalHealthTask> tasks;
  final MentalHealthState mentalHealthState;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.mentalHealthState,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Set<String> _completedTasks = {};

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      if (_completedTasks.contains(taskId)) {
        _completedTasks.remove(taskId);
      } else {
        _completedTasks.add(taskId);
      }
    });
  }

  Color _getStateColor() {
    switch (widget.mentalHealthState.name) {
      case 'Critical State':
        return CupertinoColors.systemRed;
      case 'Vulnerable State':
        return CupertinoColors.systemOrange;
      case 'Stable State':
        return CupertinoColors.activeGreen;
      case 'Thriving State':
        return CupertinoColors.activeBlue;
      default:
        return CupertinoColors.activeGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = _getStateColor();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Your Daily Tasks',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label,
          ),
        ),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: stateColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          color: stateColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.mentalHealthState.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: stateColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.mentalHealthState.description,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: CupertinoColors.secondaryLabel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_completedTasks.length}/${widget.tasks.length} Tasks Completed',
                        style: TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.systemGrey2,
                        ),
                      ),
                      if (_completedTasks.length == widget.tasks.length)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_circle_fill,
                                color: CupertinoColors.activeGreen,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'All Done!',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.activeGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.tasks.length,
                itemBuilder: (context, index) {
                  final task = widget.tasks[index];
                  final isCompleted = _completedTasks.contains(task.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _toggleTaskCompletion(task.id),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCompleted ? CupertinoColors.activeGreen : CupertinoColors.systemGrey4,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: CupertinoColors.systemGrey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: stateColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                task.icon,
                                color: stateColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isCompleted ? CupertinoColors.systemGrey : CupertinoColors.label,
                                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: isCompleted ? CupertinoColors.systemGrey2 : CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Duration: ${task.duration}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.systemGrey2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: CupertinoColors.activeGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.checkmark,
                                  color: CupertinoColors.white,
                                  size: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
