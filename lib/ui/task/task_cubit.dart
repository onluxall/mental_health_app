import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<Map<String, bool>> {
  TaskCubit() : super({
    'Morning Meditation': false,
    'Gratitude Journal': false,
    'Physical Activity': false,
    'Mindful Breathing': false,
  });

  void toggleTask(String taskTitle) {
    final currentState = Map<String, bool>.from(state);
    currentState[taskTitle] = !(currentState[taskTitle] ?? false);
    emit(currentState);
  }
} 