import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/task/task_bloc/task_bloc.dart';

import '../../data/task/data.dart';
import '../../get_it_conf.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<TaskBloc>()..add(TaskEventInit()),
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tasks'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final UserTask task = state.tasks[index];
                      final bool isCompleted = task.isCompleted ?? false;
                      return GestureDetector(
                        onTap: () {
                          context.read<TaskBloc>().add(TaskEventUpdate(
                                isCompleted: !isCompleted,
                                taskId: task.id,
                              ));
                        },
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
                              task.duration,
                              style: TextStyle(
                                color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: state.tasks.length),
              ],
            ),
          ),
        );
      }),
    );
  }
}
