import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/legacy_models/mental_health_category.dart';
import '../../data/user/interface.dart';
import '../../get_it_conf.dart';
import '../main_navigator/main_navigator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  int _currentQuestionIndex = 0;
  final List<QuizQuestion> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadQuestions() {
    _questions.addAll([
      QuizQuestion(
        question: 'How would you rate your overall mood today?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How is your energy level?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How well are you sleeping?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How would you describe your stress level?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How motivated do you feel?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How would you rate your emotional stability?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How well are you maintaining your daily routine?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How would you rate your focus and concentration?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How would you describe your social interactions?',
        value: 3.0,
      ),
      QuizQuestion(
        question: 'How well are you taking care of yourself?',
        value: 3.0,
      ),
    ]);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _controller.reverse().then((_) {
          setState(() {
            _currentQuestionIndex++;
          });
          _controller.forward();
        });
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => QuizResultsScreen(questions: _questions)),
    );
  }

  String _getResponseText(double value) {
    if (value <= 1.5) return 'Not at all';
    if (value <= 2.5) return 'Slightly';
    if (value <= 3.5) return 'Moderately';
    if (value <= 4.5) return 'Very';
    return 'Extremely';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Mental Health Assessment',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.5),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                    ),
                    FractionallySizedBox(
                      widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _questions[_currentQuestionIndex].question,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Slider(
                                value: _questions[_currentQuestionIndex].value,
                                min: 1,
                                max: 5,
                                divisions: 4,
                                onChanged: (value) {
                                  setState(() {
                                    _questions[_currentQuestionIndex].value = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Not at all',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  _getResponseText(_questions[_currentQuestionIndex].value),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  'Extremely',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1 ? 'Next Question' : 'Complete Quiz',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  double value;

  QuizQuestion({
    required this.question,
    required this.value,
  });

  QuizQuestion copyWith({
    String? question,
    double? value,
  }) {
    return QuizQuestion(
      question: question ?? this.question,
      value: value ?? this.value,
    );
  }
}

class QuizResultsScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  const QuizResultsScreen({
    super.key,
    required this.questions,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late MentalHealthState _currentState;
  late List<MentalHealthTask> _recommendedTasks;
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedTasks = {};
  int _selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _analyzeResults();
    _controller.forward();
  }

  void _analyzeResults() {
    // Calculate weighted scores for each category
    final emotionalWellbeing = (widget.questions[0].value + widget.questions[5].value + widget.questions[3].value) / 3;
    final energyMotivation = (widget.questions[1].value + widget.questions[4].value + widget.questions[7].value) / 3;
    final routineSupport = (widget.questions[2].value + widget.questions[6].value + widget.questions[8].value + widget.questions[9].value) / 4;

    // Calculate weighted average
    final weightedScore = (emotionalWellbeing * 0.4) + (energyMotivation * 0.3) + (routineSupport * 0.3);

    // Determine mental health state
    _currentState = mentalHealthStates.firstWhere(
      (state) => weightedScore >= state.minScore && weightedScore <= state.maxScore,
      orElse: () => mentalHealthStates.last,
    );

    // Get recommended tasks based on state
    _recommendedTasks = [];
    for (final category in mentalHealthCategories) {
      final tasks = category.tasks.where((task) => task.state == _currentState.name).toList();
      if (tasks.isNotEmpty) {
        _recommendedTasks.addAll(tasks.take(3));
      }
    }
  }

  void _toggleCategory(String categoryName) {
    setState(() {
      if (_selectedCategories.contains(categoryName)) {
        _selectedCategories.remove(categoryName);
        // Remove tasks from this category when unselected
        _selectedTasks.removeWhere((taskId) => _recommendedTasks.firstWhere((task) => task.id == taskId).category == categoryName);
      } else {
        _selectedCategories.add(categoryName);
      }
    });
  }

  void _toggleTask(String taskId) {
    setState(() {
      if (_selectedTasks.contains(taskId)) {
        _selectedTasks.remove(taskId);
      } else if (_selectedTasks.length < 3) {
        _selectedTasks.add(taskId);
      }
    });
  }

  List<MentalHealthTask> _getSelectedTasks() {
    final selectedTasks = <MentalHealthTask>[];
    for (final category in mentalHealthCategories) {
      if (_selectedCategories.contains(category.name)) {
        final tasks = category.tasks.where((task) => task.state == _currentState.name).take(3).toList();
        selectedTasks.addAll(tasks);
      }
    }
    return selectedTasks;
  }

  Color _getStateColor() {
    switch (_currentState.name) {
      case 'Critical State':
        return Colors.red;
      case 'Vulnerable State':
        return Colors.orange;
      case 'Stable State':
        return Colors.green;
      case 'Thriving State':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = _getStateColor();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Your Assessment',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
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
                                Icons.favorite,
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
                                    _currentState.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: stateColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentState.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.4,
                                      color: Colors.grey,
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
                  const SizedBox(height: 24),
                  const Text(
                    'Choose Your Focus Areas',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select categories for your personalized tasks',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: mentalHealthCategories.map((category) {
                        final isSelected = _selectedCategories.contains(category.name);
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _toggleCategory(category.name),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? stateColor.withOpacity(0.1) : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? stateColor : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: isSelected ? stateColor : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (_selectedCategories.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Personalized Tasks',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${_selectedTasks.length}/3 selected',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._getSelectedTasks().map((task) {
                      final isSelected = _selectedTasks.contains(task.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _toggleTask(task.id),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? stateColor : Colors.grey.shade300,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
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
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Duration: ${task.duration}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: stateColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: stateColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        final IUserRepo userRepo = getIt.get<IUserRepo>();
                        await userRepo.updateQuizCompleted(id: userId ?? "", quizCompleted: true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MainNavigator(),
                        ));
                      },
                      child: const Text(
                        'Start Your Journey',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
