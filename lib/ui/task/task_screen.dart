import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/task/task_bloc/task_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Recommended Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedTasks.length,
                      itemBuilder: (context, index) {
                        final task = recommendedTasks[index];
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(left: 16),
                          child: TaskCard(
                            taskId: task.id,
                            title: task.title,
                            description: task.description,
                            isAccepted: false,
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Your Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: userTasks.length,
                    itemBuilder: (context, index) {
                      final task = userTasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TaskCard(
                          taskId: task.id,
                          title: task.title,
                          description: task.description,
                          isAccepted: false,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final bool isAccepted;

  const TaskCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          print('Task $taskId tapped');
          // context.read<TaskBloc>().add(ToggleTaskAcceptanceEvent(taskId));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAccepted ? Colors.green.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isAccepted ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    isAccepted ? Icons.check_circle : Icons.circle_outlined,
                    color: isAccepted ? Colors.green : Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final String dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

final List<Task> recommendedTasks = [
  Task(
    id: '1',
    title: 'Inspect Fire Safety Equipment',
    description: 'Check all fire extinguishers and emergency exits in the building',
    dueDate: 'Due in 2 days',
  ),
  Task(
    id: '2',
    title: 'Monthly Maintenance Check',
    description: 'Perform routine maintenance on HVAC systems',
    dueDate: 'Due in 5 days',
  ),
  Task(
    id: '3',
    title: 'Garden Maintenance',
    description: 'Trim hedges and water plants in the common areas',
    dueDate: 'Due in 3 days',
  ),
  Task(
    id: '4',
    title: 'Security System Check',
    description: 'Test all security cameras and alarms',
    dueDate: 'Due in 1 day',
  ),
];

final List<Task> userTasks = [
  Task(
    id: '5',
    title: 'Clean Common Areas',
    description: 'Sweep and mop floors in the lobby and hallways',
    dueDate: 'Due today',
  ),
  Task(
    id: '6',
    title: 'Check Mailboxes',
    description: 'Ensure all mailboxes are properly locked and functioning',
    dueDate: 'Due tomorrow',
  ),
  Task(
    id: '7',
    title: 'Parking Lot Inspection',
    description: 'Check for any damages or issues in the parking area',
    dueDate: 'Due in 3 days',
  ),
  Task(
    id: '8',
    title: 'Trash Collection',
    description: 'Organize and schedule trash collection for the week',
    dueDate: 'Due in 2 days',
  ),
];
