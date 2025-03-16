import 'package:flutter/cupertino.dart';
import '../models/mental_health_category.dart';

class HomeScreen extends StatelessWidget {
  final MentalHealthState? mentalHealthState;
  final List<MentalHealthTask>? selectedTasks;

  const HomeScreen({
    super.key,
    this.mentalHealthState,
    this.selectedTasks,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: Center(
        child: Text('Home Screen - Coming Soon'),
      ),
    );
  }
} 