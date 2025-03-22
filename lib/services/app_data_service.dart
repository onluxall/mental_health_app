import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import '../data/legacy_models/journal_entry.dart';
import '../data/legacy_models/mental_health_category.dart';
import '../data/legacy_models/mood_entry.dart';
import '../data/legacy_models/quiz_question.dart';
import '../widgets/activity_note_panel.dart';

class AppDataService {
  static const String _fileName = 'mental_health_app_data.json';
  static const String _moodEntriesKey = 'mood_entries';
  static const String _activityNotesKey = 'activity_notes';
  static const String _dailyMoodKey = 'daily_mood';
  static const String _dailyNoteKey = 'daily_note';
  static const String _completedTasksKey = 'completed_tasks';
  static const String _tasksKey = 'tasks';
  static const String _journalEntriesKey = 'journal_entries';
  static AppDataService? _instance;
  static AppDataService get instance => _instance ??= AppDataService._();

  AppDataService._();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<void> saveDailyMood({
    required double mood,
    required List<String> emotions,
    required String? note,
  }) async {
    final data = await loadAppData() ?? {};
    data[_dailyMoodKey] = {
      'mood': mood,
      'emotions': emotions,
      'note': note,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _saveData(data);
  }

  Future<Map<String, dynamic>?> getDailyMood() async {
    final data = await loadAppData();
    if (data == null) return null;
    return data[_dailyMoodKey];
  }

  Future<void> saveDailyNote(String note) async {
    final data = await loadAppData() ?? {};
    data[_dailyNoteKey] = {
      'note': note,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _saveData(data);
  }

  Future<String?> getDailyNote() async {
    final data = await loadAppData();
    if (data == null) return null;
    return data[_dailyNoteKey]?['note'];
  }

  Future<void> saveCompletedTask(String taskId) async {
    final tasks = await getTasks();
    final updatedTasks = tasks.map((task) {
      if (task.id == taskId) {
        return MentalHealthTask(
          id: task.id,
          title: task.title,
          description: task.description,
          icon: task.icon,
          duration: task.duration,
          state: task.state,
          category: task.category,
          isCompleted: true,
        );
      }
      return task;
    }).toList();
    await saveTasks(updatedTasks);
  }

  Future<Set<String>> getCompletedTasks() async {
    final data = await loadAppData();
    if (data == null) return {};
    return Set<String>.from(data[_completedTasksKey] ?? []);
  }

  Future<void> saveMoodEntry(MoodEntry entry) async {
    final data = await loadAppData() ?? {};
    final entries = List<Map<String, dynamic>>.from(data[_moodEntriesKey] ?? []);
    entries.add(entry.toJson());
    data[_moodEntriesKey] = entries;
    await _saveData(data);
  }

  Future<List<MoodEntry>> getMoodEntries() async {
    final data = await loadAppData();
    if (data == null) return [];

    final entries = List<Map<String, dynamic>>.from(data[_moodEntriesKey] ?? []);
    return entries.map((entry) => MoodEntry.fromJson(entry)).toList();
  }

  Future<void> saveActivityNote(ActivityNote note) async {
    final data = await loadAppData() ?? {};
    final notes = (data[_activityNotesKey] as List?) ?? [];
    notes.add({
      'title': note.title,
      'note': note.note,
      'duration': note.duration,
      'icon': note.icon.codePoint.toString(),
      'color': note.color.value,
      'timestamp': note.timestamp.toIso8601String(),
    });
    data[_activityNotesKey] = notes;
    await _saveData(data);
  }

  Future<List<ActivityNote>> getActivityNotes() async {
    final data = await loadAppData();
    if (data == null) return [];

    final notes = (data[_activityNotesKey] as List?) ?? [];
    return notes
        .map((note) => ActivityNote(
              title: note['title'] as String,
              note: note['note'] as String,
              duration: note['duration'] as String,
              icon: IconData(int.parse(note['icon'] as String), fontFamily: 'CupertinoIcons'),
              color: Color(note['color'] as int),
              timestamp: DateTime.parse(note['timestamp'] as String),
            ))
        .toList();
  }

  Future<void> deleteActivityNote(DateTime timestamp) async {
    final data = await loadAppData() ?? {};
    final notes = List<Map<String, dynamic>>.from(data[_activityNotesKey] ?? []);
    notes.removeWhere((note) => DateTime.parse(note['timestamp'] as String) == timestamp);
    data[_activityNotesKey] = notes;
    await _saveData(data);
  }

  Future<void> _saveData(Map<String, dynamic> data) async {
    final file = await _localFile;
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> saveAppData({
    required bool hasCompletedQuiz,
    required MentalHealthState currentState,
    required List<MentalHealthTask> selectedTasks,
    required List<QuizQuestion> quizQuestions,
    List<Map<String, dynamic>>? journalEntries,
    Map<String, dynamic>? therapySessions,
  }) async {
    final data = {
      'has_completed_quiz': hasCompletedQuiz,
      'mental_health_state': currentState.name,
      'selected_tasks': selectedTasks
          .map((task) => {
                'id': task.id,
                'title': task.title,
                'description': task.description,
                'icon': task.icon.codePoint.toString(),
                'duration': task.duration,
                'state': task.state,
                'category': task.category,
              })
          .toList(),
      'quiz_questions': quizQuestions
          .map((q) => {
                'question': q.question,
                'value': q.value,
              })
          .toList(),
      'journal_entries': journalEntries ?? [],
      'therapy_sessions': therapySessions ?? {},
      'last_updated': DateTime.now().toIso8601String(),
    };

    await _saveData(data);
  }

  Future<Map<String, dynamic>?> loadAppData() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return null;

      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      print('Error loading app data: $e');
      return null;
    }
  }

  Future<void> resetAppData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error resetting app data: $e');
    }
  }

  Future<bool> hasCompletedQuiz() async {
    final data = await loadAppData();
    return data?['has_completed_quiz'] ?? false;
  }

  Future<MentalHealthState?> getCurrentState() async {
    final data = await loadAppData();
    if (data == null) return null;

    final stateName = data['mental_health_state'];
    return mentalHealthStates.firstWhere(
      (state) => state.name == stateName,
      orElse: () => mentalHealthStates[2],
    );
  }

  Future<List<MentalHealthTask>> getSelectedTasks() async {
    final data = await loadAppData();
    if (data == null) return [];

    final tasks = data['selected_tasks'] as List;
    return tasks
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
  }

  Future<List<QuizQuestion>> getQuizQuestions() async {
    final data = await loadAppData();
    if (data == null) return [];

    final questions = data['quiz_questions'] as List;
    return questions
        .map((q) => QuizQuestion(
              question: q['question'],
              value: q['value'],
            ))
        .toList();
  }

  Future<void> saveTasks(List<MentalHealthTask> tasks) async {
    final data = await loadAppData() ?? {};
    data[_tasksKey] = tasks
        .map((task) => {
              'id': task.id,
              'title': task.title,
              'description': task.description,
              'icon': task.icon.codePoint.toString(),
              'duration': task.duration,
              'state': task.state,
              'category': task.category,
              'isCompleted': task.isCompleted,
            })
        .toList();
    await _saveData(data);
  }

  Future<List<MentalHealthTask>> getTasks() async {
    final data = await loadAppData();
    if (data == null) return [];

    final tasks = (data[_tasksKey] as List?) ?? [];
    return tasks
        .map((task) => MentalHealthTask(
              id: task['id'] as String,
              title: task['title'] as String,
              description: task['description'] as String,
              icon: IconData(int.parse(task['icon'] as String), fontFamily: 'CupertinoIcons'),
              duration: task['duration'] as String,
              state: task['state'] as String,
              category: task['category'] as String,
              isCompleted: task['isCompleted'] as bool,
            ))
        .toList();
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final data = await loadAppData() ?? {};
    final entries = List<Map<String, dynamic>>.from(data[_journalEntriesKey] ?? []);
    entries.add(entry.toJson());
    data[_journalEntriesKey] = entries;
    await _saveData(data);
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final data = await loadAppData();
    if (data == null) return [];

    final entries = (data[_journalEntriesKey] as List?) ?? [];
    return entries
        .map((entry) {
          if (entry is Map<String, dynamic>) {
            return JournalEntry.fromJson(entry);
          }
          return null;
        })
        .whereType<JournalEntry>()
        .toList();
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    final data = await loadAppData() ?? {};
    final entries = List<Map<String, dynamic>>.from(data[_journalEntriesKey] ?? []);
    final index = entries.indexWhere((e) => e['id'] == entry.id);
    if (index != -1) {
      entries[index] = entry.toJson();
      data[_journalEntriesKey] = entries;
      await _saveData(data);
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    final data = await loadAppData() ?? {};
    final entries = List<Map<String, dynamic>>.from(data[_journalEntriesKey] ?? []);
    entries.removeWhere((entry) => entry['id'] == id);
    data[_journalEntriesKey] = entries;
    await _saveData(data);
  }
}
