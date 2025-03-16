import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/therapist_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/quiz_screen.dart';
import 'models/mental_health_category.dart';
import 'models/quiz_question.dart';

void main() {
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Mental Health App',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeGreen,
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
      ),
      home: const MainNavigator(),
      routes: {
        '/tasks': (context) => TasksScreen(
          tasks: [],
          mentalHealthState: mentalHealthStates[2], // Stable State
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
      _saveQuizData(_currentState, _selectedTasks, _quizQuestions);
    } else {
      _currentState = mentalHealthStates[2];
      _selectedTasks = [];
      _quizQuestions = [];
      _loadSavedData();
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedQuiz = prefs.getBool('has_completed_quiz') ?? false;
    
    if (!hasCompletedQuiz) {
      _showQuiz();
    } else {
      final savedState = prefs.getString('mental_health_state');
      final savedTasks = prefs.getString('selected_tasks');
      final savedQuestions = prefs.getString('quiz_questions');

      if (savedState != null && savedTasks != null) {
        setState(() {
          _currentState = mentalHealthStates.firstWhere(
            (state) => state.name == savedState,
            orElse: () => mentalHealthStates[2],
          );
          _selectedTasks = (jsonDecode(savedTasks) as List)
              .map((task) => MentalHealthTask(
                    id: task['id'],
                    title: task['title'],
                    description: task['description'],
                    icon: CupertinoIcons.home,
                    duration: task['duration'],
                    state: task['state'],
                    category: task['category'],
                  ))
              .toList();
          _hasCompletedQuiz = true;
        });
      }
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
      
      await _saveQuizData(state, tasks, questions);
      
      setState(() {
        _currentState = state;
        _selectedTasks = tasks;
        _quizQuestions = questions;
        _hasCompletedQuiz = true;
      });
    }
  }

  Future<void> _saveQuizData(MentalHealthState state, List<MentalHealthTask> tasks, List<QuizQuestion> questions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_quiz', true);
    await prefs.setString('mental_health_state', state.name);
    await prefs.setString('selected_tasks', jsonEncode(tasks.map((task) => {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'duration': task.duration,
      'state': task.state,
      'category': task.category,
    }).toList()));
    await prefs.setString('quiz_questions', jsonEncode(questions.map((q) => {
      'question': q.question,
      'value': q.value,
    }).toList()));
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
