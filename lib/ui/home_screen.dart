import 'package:flutter/cupertino.dart';

import '../data/legacy_models/mental_health_category.dart';
import '../data/legacy_models/mood_entry.dart';
import '../services/app_data_service.dart';
import '../ui/edit_note_screen.dart';
import '../widgets/activity_details_sheet.dart';
import '../widgets/activity_note_panel.dart';

class HomeScreen extends StatefulWidget {
  final MentalHealthState? mentalHealthState;
  final List<MentalHealthTask>? selectedTasks;

  const HomeScreen({
    super.key,
    this.mentalHealthState,
    this.selectedTasks,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dailyNote = '';
  double _currentMood = 3.0; // Default to "Okay"
  bool _hasInteractedWithSlider = false;
  final List<String> _emotions = [];
  final Set<String> _selectedEmotions = {};
  DateTime? _lastMoodUpdate;
  bool _isSaving = false;
  bool _isNoteExpanded = false;
  final TextEditingController _noteController = TextEditingController();
  List<ActivityNote> _activityNotes = [];
  final List<Map<String, dynamic>> _recommendedActivities = [
    {
      'title': 'Morning Meditation',
      'duration': '10 min',
      'note': 'Start your day with mindfulness',
      'icon': CupertinoIcons.heart,
    },
    {
      'title': 'Evening Journal',
      'duration': '15 min',
      'note': 'Reflect on your day',
      'icon': CupertinoIcons.book,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadActivityNotes();
    _loadDailyData();
    _loadTasks();
  }

  Future<void> _loadActivityNotes() async {
    final notes = await AppDataService.instance.getActivityNotes();
    setState(() {
      _activityNotes = notes;
    });
  }

  Future<void> _loadDailyData() async {
    // Load daily note
    final savedNote = await AppDataService.instance.getDailyNote();
    if (savedNote != null) {
      setState(() {
        _dailyNote = savedNote;
        _noteController.text = savedNote;
      });
    }

    // Load daily mood
    final savedMood = await AppDataService.instance.getDailyMood();
    if (savedMood != null) {
      setState(() {
        _currentMood = savedMood['mood'] as double;
        _selectedEmotions.clear();
        _selectedEmotions.addAll((savedMood['emotions'] as List).cast<String>());
        _hasInteractedWithSlider = true;
        _emotions.clear();
        _emotions.addAll(_getEmotionsForMood(_currentMood));
      });
    }
  }

  Future<void> _loadTasks() async {
    if (widget.selectedTasks != null) {
      final savedTasks = await AppDataService.instance.getTasks();
      setState(() {
        widget.selectedTasks!.clear();
        widget.selectedTasks!.addAll(savedTasks);
      });
    }
  }

  Future<void> _saveTasks() async {
    if (widget.selectedTasks != null) {
      await AppDataService.instance.saveTasks(widget.selectedTasks!);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getMoodText(double value) {
    if (value <= 1) return 'Terrible';
    if (value <= 2) return 'Bad';
    if (value <= 3) return 'Okay';
    if (value <= 4) return 'Good';
    return 'Great';
  }

  IconData _getMoodIcon(double value) {
    if (value <= 1) return CupertinoIcons.minus_circle_fill;
    if (value <= 2) return CupertinoIcons.minus_circle;
    if (value <= 3) return CupertinoIcons.circle;
    if (value <= 4) return CupertinoIcons.plus_circle;
    return CupertinoIcons.plus_circle_fill;
  }

  Color _getMoodColor(double value) {
    if (value <= 1) return CupertinoColors.systemRed;
    if (value <= 2) return CupertinoColors.systemOrange;
    if (value <= 3) return CupertinoColors.systemYellow;
    if (value <= 4) return CupertinoColors.systemBlue;
    return CupertinoColors.systemGreen;
  }

  List<String> _getEmotionsForMood(double mood) {
    if (mood <= 1)
      return [
        'Sad',
        'Angry',
        'Frustrated',
        'Overwhelmed',
        'Hopeless',
        'Exhausted',
        'Devastated',
        'Despairing',
        'Miserable',
        'Lonely',
        'Terrified',
        'Panicked',
        'Worthless',
        'Guilty',
        'Ashamed',
        'Humiliated',
        'Powerless',
        'Trapped'
      ];
    if (mood <= 2)
      return [
        'Anxious',
        'Tired',
        'Stressed',
        'Disappointed',
        'Worried',
        'Irritable',
        'Nervous',
        'Restless',
        'Uneasy',
        'Tense',
        'Overwhelmed',
        'Confused',
        'Discouraged',
        'Frustrated',
        'Annoyed',
        'Impatient',
        'Insecure',
        'Vulnerable',
        'Exhausted',
        'Drained',
        'Fatigued',
        'Weary'
      ];
    if (mood <= 3)
      return [
        'Calm',
        'Neutral',
        'Content',
        'Balanced',
        'Peaceful',
        'Relaxed',
        'Stable',
        'Centered',
        'Present',
        'Mindful',
        'Accepting',
        'Patient',
        'Satisfied',
        'Comfortable',
        'Secure',
        'Grounded',
        'Focused',
        'Clear',
        'Tranquil',
        'Serene',
        'At ease',
        'Steady'
      ];
    if (mood <= 4)
      return [
        'Happy',
        'Energetic',
        'Motivated',
        'Grateful',
        'Optimistic',
        'Focused',
        'Joyful',
        'Excited',
        'Enthusiastic',
        'Inspired',
        'Confident',
        'Proud',
        'Appreciative',
        'Blessed',
        'Fulfilled',
        'Accomplished',
        'Determined',
        'Driven',
        'Vibrant',
        'Alive',
        'Thriving',
        'Flourishing'
      ];
    return [
      'Excited',
      'Joyful',
      'Confident',
      'Inspired',
      'Enthusiastic',
      'Empowered',
      'Elated',
      'Ecstatic',
      'Radiant',
      'Blissful',
      'Euphoric',
      'Wonderful',
      'Magnificent',
      'Amazing',
      'Incredible',
      'Fantastic',
      'Brilliant',
      'Spectacular',
      'Triumphant',
      'Victorious',
      'Unstoppable',
      'Invincible'
    ];
  }

  MoodLevel _getMoodLevel(double value) {
    if (value <= 1) return MoodLevel.terrible;
    if (value <= 2) return MoodLevel.bad;
    if (value <= 3) return MoodLevel.okay;
    if (value <= 4) return MoodLevel.good;
    return MoodLevel.great;
  }

  Future<void> _saveMoodEntry() async {
    if (!_hasInteractedWithSlider || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final entry = MoodEntry(
        timestamp: DateTime.now(),
        moodLevel: _getMoodLevel(_currentMood),
        emotions: _selectedEmotions.toList(),
        note: _dailyNote.isNotEmpty ? _dailyNote : null,
      );

      await AppDataService.instance.saveMoodEntry(entry);
      await AppDataService.instance.saveDailyMood(
        mood: _currentMood,
        emotions: _selectedEmotions.toList(),
        note: _dailyNote.isNotEmpty ? _dailyNote : null,
      );
      _lastMoodUpdate = DateTime.now();
    } catch (e) {
      print('Error saving mood entry: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showActivityDetails(
    BuildContext context, {
    required String title,
    required String note,
    required String duration,
    required IconData icon,
    required Color color,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => ActivityDetailsSheet(
        title: title,
        note: note,
        duration: duration,
        icon: icon,
        color: color,
        onSave: (note, duration) async {
          // Only save to recent activities if it's not a task
          final isTask = widget.selectedTasks?.any((task) => task.title == title) ?? false;
          if (!isTask) {
            final activityNote = ActivityNote(
              title: title,
              note: note,
              duration: duration,
              icon: icon,
              color: color,
              timestamp: DateTime.now(),
            );

            await AppDataService.instance.saveActivityNote(activityNote);
            setState(() {
              _activityNotes.insert(0, activityNote);
            });
          } else {
            // If it's a task, mark it as completed
            final task = widget.selectedTasks!.firstWhere((t) => t.title == title);
            await AppDataService.instance.saveCompletedTask(task.id);
            await _saveTasks();
          }
        },
      ),
    );
  }

  void _editActivityNote(ActivityNote note) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditNoteScreen(
          note: note,
          onSave: (updatedNote) async {
            await AppDataService.instance.saveActivityNote(updatedNote);
            setState(() {
              final index = _activityNotes.indexWhere((n) => n.timestamp == note.timestamp);
              if (index != -1) {
                _activityNotes[index] = updatedNote;
              }
            });
          },
          onDelete: (deletedNote) {
            setState(() {
              _activityNotes.removeWhere((n) => n.timestamp == deletedNote.timestamp);
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Home'),
        backgroundColor: CupertinoColors.systemBackground,
        border: null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.person_circle),
          onPressed: () {
            // TODO: Navigate to profile
          },
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping anywhere
            FocusScope.of(context).unfocus();
          },
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()}, User!',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 17,
                          color: CupertinoColors.systemGrey.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Activity Notes Panel
              if (_activityNotes.isNotEmpty)
                SliverToBoxAdapter(
                  child: ActivityNotePanel(
                    notes: _activityNotes,
                    onEdit: _editActivityNote,
                  ),
                ),

              // Daily Note Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17.0, 0, 17.0, 0),
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: CupertinoColors.systemGroupedBackground,
                    margin: EdgeInsets.zero,
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Note',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateTime.now().toString().split(' ')[0],
                          style: TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.systemGrey.resolveFrom(context),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      CupertinoListTile.notched(
                        title: CupertinoTextField(
                          controller: _noteController..text = _dailyNote,
                          placeholder: 'What\'s on your mind?',
                          onChanged: (value) async {
                            setState(() {
                              _dailyNote = value;
                            });
                            await AppDataService.instance.saveDailyNote(value);
                          },
                          maxLines: 1,
                          decoration: null,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              CupertinoIcons.pencil,
                              size: 20,
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                          ),
                          suffix: _dailyNote.isNotEmpty
                              ? CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: const Icon(CupertinoIcons.clear),
                                  onPressed: () async {
                                    setState(() {
                                      _dailyNote = '';
                                      _noteController.clear();
                                    });
                                    await AppDataService.instance.saveDailyNote('');
                                  },
                                )
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ],
                  ),
                ),
              ),

              // Mood Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17.0, 0, 17.0, 0),
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: CupertinoColors.systemGroupedBackground,
                    margin: EdgeInsets.zero,
                    header: const Text(
                      'How are you feeling?',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      CupertinoListTile.notched(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Not great',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey.resolveFrom(context),
                                    ),
                                  ),
                                  Text(
                                    'Great',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.systemGrey.resolveFrom(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoSlider(
                              value: _currentMood,
                              min: 1,
                              max: 5,
                              divisions: 4,
                              activeColor: _getMoodColor(_currentMood),
                              onChanged: (value) {
                                setState(() {
                                  _currentMood = value;
                                  _hasInteractedWithSlider = true;
                                  _emotions.clear();
                                  _emotions.addAll(_getEmotionsForMood(value));
                                });
                                _saveMoodEntry();
                              },
                            ),
                            const SizedBox(height: 8),
                            if (_hasInteractedWithSlider)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getMoodText(_currentMood),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: _getMoodColor(_currentMood),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            if (_hasInteractedWithSlider)
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 6,
                                runSpacing: 6,
                                children: _emotions.map((emotion) {
                                  final isSelected = _selectedEmotions.contains(emotion);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedEmotions.remove(emotion);
                                        } else {
                                          _selectedEmotions.add(emotion);
                                        }
                                      });
                                      _saveMoodEntry();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected ? _getMoodColor(_currentMood) : _getMoodColor(_currentMood).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getMoodColor(_currentMood),
                                          width: isSelected ? 0 : 1,
                                        ),
                                      ),
                                      child: Text(
                                        emotion,
                                        style: TextStyle(
                                          color: isSelected ? CupertinoColors.white : _getMoodColor(_currentMood),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            if (_isSaving)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: CupertinoActivityIndicator(),
                              ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ],
                  ),
                ),
              ),

              // Recommended Activities Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recommended Activities',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('See All'),
                        onPressed: () {
                          // TODO: Navigate to all activities
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final activity = _recommendedActivities[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CupertinoColors.systemGrey5,
                            width: 1,
                          ),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _showActivityDetails(
                              context,
                              title: activity['title'],
                              note: activity['note'],
                              duration: activity['duration'],
                              icon: activity['icon'],
                              color: CupertinoTheme.of(context).primaryColor,
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  activity['icon'],
                                  size: 32,
                                  color: CupertinoTheme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                activity['title'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                activity['note'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.systemGrey.resolveFrom(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  activity['duration'],
                                  style: TextStyle(
                                    color: CupertinoTheme.of(context).primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _recommendedActivities.length,
                  ),
                ),
              ),

              // All Activities Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Activities',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('See All'),
                        onPressed: () {
                          // TODO: Navigate to all activities
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.heart,
                      title: 'Meditation',
                      color: CupertinoColors.systemPink,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.book,
                      title: 'Journaling',
                      color: CupertinoColors.systemBlue,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.wind,
                      title: 'Breathing',
                      color: CupertinoColors.systemGreen,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.music_note_2,
                      title: 'Music',
                      color: CupertinoColors.systemOrange,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.sportscourt,
                      title: 'Exercise',
                      color: CupertinoColors.systemPurple,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.moon,
                      title: 'Sleep',
                      color: CupertinoColors.systemIndigo,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.person_2,
                      title: 'Social',
                      color: CupertinoColors.systemTeal,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.paintbrush,
                      title: 'Art',
                      color: CupertinoColors.systemRed,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.sun_max,
                      title: 'Nature',
                      color: CupertinoColors.systemGreen,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.chat_bubble_2,
                      title: 'Therapy',
                      color: CupertinoColors.systemBlue,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.game_controller,
                      title: 'Games',
                      color: CupertinoColors.systemYellow,
                    ),
                    _buildActivityCard(
                      context,
                      icon: CupertinoIcons.heart_circle,
                      title: 'Self Care',
                      color: CupertinoColors.systemPink,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5,
          width: 1,
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _showActivityDetails(
            context,
            title: title,
            note: 'A calming practice to help you find peace and clarity in your daily life.',
            duration: '10 min',
            icon: CupertinoIcons.heart_circle_fill,
            color: CupertinoColors.systemPink,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
