import 'package:flutter/cupertino.dart';

import '../data/legacy_models/mental_health_category.dart';
import '../data/legacy_models/quiz_question.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = _getStateColor();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Your Assessment',
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
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(16),
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
                                      color: CupertinoColors.secondaryLabel,
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
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select categories for your personalized tasks',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey2,
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
                                color: isSelected ? stateColor.withOpacity(0.1) : CupertinoColors.systemBackground,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? stateColor : CupertinoColors.systemGrey4,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: isSelected ? stateColor : CupertinoColors.label,
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
                            color: CupertinoColors.label,
                          ),
                        ),
                        Text(
                          '${_selectedTasks.length}/3 selected',
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey2,
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
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? stateColor : CupertinoColors.systemGrey4,
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
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.label,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        task.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                          color: CupertinoColors.secondaryLabel,
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
                                if (isSelected)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: stateColor,
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
                    }).toList(),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      color: CupertinoColors.activeGreen,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () {
                        if (_selectedTasks.length == 3) {
                          final selectedTasksList = _getSelectedTasks().where((task) => _selectedTasks.contains(task.id)).toList();
                          // Navigator.of(context).pushAndRemoveUntil(
                          //   CupertinoPageRoute(
                          //     builder: (context) => MainNavigator(
                          //       initialState: _currentState,
                          //       initialTasks: selectedTasksList,
                          //       initialQuestions: widget.questions,
                          //     ),
                          //   ),
                          //   (route) => false,
                          // );
                        }
                      },
                      child: const Text(
                        'Start Your Journey',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.white,
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
