import 'package:flutter/cupertino.dart';

import '../data/quiz_question.dart';
import 'quiz_results_screen.dart';

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
      CupertinoPageRoute(
        builder: (context) => QuizResultsScreen(
          questions: _questions,
        ),
      ),
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Mental Health Assessment',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label,
          ),
        ),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        border: null,
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
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
                      color: CupertinoColors.systemGrey6,
                    ),
                    FractionallySizedBox(
                      widthFactor: (_currentQuestionIndex + 1) / _questions.length,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CupertinoColors.activeGreen,
                              CupertinoColors.activeGreen.withOpacity(0.8),
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
                          style: const TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _questions[_currentQuestionIndex].question,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoSlider(
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
                                const Text(
                                  'Not at all',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey2,
                                  ),
                                ),
                                Text(
                                  _getResponseText(_questions[_currentQuestionIndex].value),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.activeGreen,
                                  ),
                                ),
                                const Text(
                                  'Extremely',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey2,
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
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(10),
                  pressedOpacity: 0.7,
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
