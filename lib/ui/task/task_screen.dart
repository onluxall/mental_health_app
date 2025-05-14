import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/task/task_bloc/task_bloc.dart';
import 'package:mental_health_app/ui/task/task_card.dart';

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
                      final isCompleted = task.isCompleted ?? false;
                      return TaskCard(
                        onTap: () => context.read<TaskBloc>().add(TaskEventUpdate(
                              isCompleted: !isCompleted,
                              taskId: task.id,
                            )),
                        task: task,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemCount: state.tasks.length),
              ],
            ),
          ),
        );
      }),
    );
  }
}
