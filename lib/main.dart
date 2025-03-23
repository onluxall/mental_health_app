import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/ui/auth/auth_switch.dart';

import 'data/legacy_models/mental_health_category.dart';
import 'data/legacy_models/quiz_question.dart';
import 'firebase_options.dart';
import 'get_it_conf.dart';
import 'services/app_data_service.dart';
import 'ui/home/home_screen.dart';
import 'ui/journal_screen.dart';
import 'ui/quiz_screen.dart';
import 'ui/tasks_screen.dart';
import 'ui/therapist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      debugShowCheckedModeBanner: false,
      home: const AuthSwitch(),
      routes: {
        '/tasks': (context) => TasksScreen(
              tasks: [],
              mentalHealthState: mentalHealthStates[2],
            ),
      },
    );
  }
}

class MainNavigator extends StatefulWidget {
  final MentalHealthState? initialState;
  final List<MentalHealthTask>? initialTasks;
  final List<QuizQuestion>? initialQuestions;

  const MainNavigator({
    super.key,
    this.initialState,
    this.initialTasks,
    this.initialQuestions,
  });

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  bool _hasCompletedQuiz = false;
  late MentalHealthState _currentState;
  late List<MentalHealthTask> _selectedTasks;
  late List<QuizQuestion> _quizQuestions;

  @override
  void initState() {
    super.initState();
    if (widget.initialState != null && widget.initialTasks != null) {
      _currentState = widget.initialState!;
      _selectedTasks = widget.initialTasks!;
      _quizQuestions = widget.initialQuestions ?? [];
      _hasCompletedQuiz = true;
      _saveAppData();
    } else {
      _currentState = mentalHealthStates[2];
      _selectedTasks = [];
      _quizQuestions = [];
      _checkAndLoadData();
    }
  }

  Future<void> _checkAndLoadData() async {
    final hasCompletedQuiz = await AppDataService.instance.hasCompletedQuiz();

    if (hasCompletedQuiz) {
      final currentState = await AppDataService.instance.getCurrentState();
      final selectedTasks = await AppDataService.instance.getSelectedTasks();
      final quizQuestions = await AppDataService.instance.getQuizQuestions();

      if (currentState != null && selectedTasks.isNotEmpty) {
        setState(() {
          _currentState = currentState;
          _selectedTasks = selectedTasks;
          _quizQuestions = quizQuestions;
          _hasCompletedQuiz = true;
        });
      } else {
        // If data is incomplete, reset and show quiz
        await AppDataService.instance.resetAppData();
        _showQuiz();
      }
    } else {
      _showQuiz();
    }
  }

  Future<void> _showQuiz() async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const QuizScreen(),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      final state = result['state'] as MentalHealthState;
      final tasks = result['tasks'] as List<MentalHealthTask>;
      final questions = result['questions'] as List<QuizQuestion>;

      setState(() {
        _currentState = state;
        _selectedTasks = tasks;
        _quizQuestions = questions;
        _hasCompletedQuiz = true;
      });

      await _saveAppData();
    }
  }

  Future<void> _saveAppData() async {
    await AppDataService.instance.saveAppData(
      hasCompletedQuiz: _hasCompletedQuiz,
      currentState: _currentState,
      selectedTasks: _selectedTasks,
      quizQuestions: _quizQuestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(
        mentalHealthState: _currentState,
        selectedTasks: _selectedTasks,
      ),
      const JournalScreen(),
      const TherapistScreen(),
      TasksScreen(
        tasks: _selectedTasks,
        mentalHealthState: _currentState,
      ),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Therapist',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.checkmark_circle),
            label: 'Tasks',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) => _screens[index],
        );
      },
    );
  }
}
