import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_cubit.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = [
      _Task(
        title: 'Morning Meditation',
        duration: '10 min',
      ),
      _Task(
        title: 'Gratitude Journal',
        duration: '5 min',
      ),
      _Task(
        title: 'Physical Activity',
        duration: '30 min',
      ),
      _Task(
        title: 'Mindful Breathing',
        duration: '5 min',
      ),
    ];

    return BlocBuilder<TaskCubit, Map<String, bool>>(
      builder: (context, state) {
        return Column(
          children: tasks.map((task) => _TaskCard(
            task: task,
            isCompleted: state[task.title] ?? false,
            onTap: () => context.read<TaskCubit>().toggleTask(task.title),
          )).toList(),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final _Task task;
  final bool isCompleted;
  final VoidCallback onTap;

  const _TaskCard({
    required this.task,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
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
            task.duration,
            style: TextStyle(
              color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Task {
  final String title;
  final String duration;

  _Task({
    required this.title,
    required this.duration,
  });
}
