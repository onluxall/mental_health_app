import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../data/legacy_models/journal_entry.dart';
import '../../services/app_data_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<JournalEntry>> _entriesByDay = {};

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    final entries = await AppDataService.instance.getJournalEntries();
    setState(() {
      _entries = entries;
      _organizeEntriesByDay();
      _isLoading = false;
    });
  }

  void _organizeEntriesByDay() {
    _entriesByDay = {};
    for (var entry in _entries) {
      final date = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );
      if (!_entriesByDay.containsKey(date)) {
        _entriesByDay[date] = [];
      }
      _entriesByDay[date]!.add(entry);
    }
  }

  List<JournalEntry> _getEntriesForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _entriesByDay[date] ?? [];
  }

  void _showNewEntrySheet() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    double moodValue = 3.0;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('New Journal Entry'),
        message: Column(
          children: [
            CupertinoTextField(
              controller: titleController,
              placeholder: 'Title',
              padding: const EdgeInsets.all(16),
            ),
            CupertinoTextField(
              controller: contentController,
              placeholder: 'Write your thoughts...',
              padding: const EdgeInsets.all(16),
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How are you feeling?'),
                  CupertinoSlider(
                    value: moodValue,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      moodValue = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                final entry = JournalEntry(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  content: contentController.text,
                  timestamp: _selectedDay,
                  mood: moodValue,
                );
                await AppDataService.instance.saveJournalEntry(entry);
                if (mounted) {
                  Navigator.pop(context);
                  _loadEntries();
                }
              }
            },
            child: const Text('Save'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEntryDetails(JournalEntry entry) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(entry.title),
        message: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Mood: ${_getMoodText(entry.mood)}',
              style: TextStyle(
                color: _getMoodColor(entry.mood),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${_formatDate(entry.timestamp)}',
              style: const TextStyle(color: CupertinoColors.systemGrey),
            ),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _showEditEntrySheet(entry);
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              await AppDataService.instance.deleteJournalEntry(entry.id);
              if (mounted) {
                Navigator.pop(context);
                _loadEntries();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditEntrySheet(JournalEntry entry) {
    final titleController = TextEditingController(text: entry.title);
    final contentController = TextEditingController(text: entry.content);
    double moodValue = entry.mood;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Edit Journal Entry'),
        message: Column(
          children: [
            CupertinoTextField(
              controller: titleController,
              placeholder: 'Title',
              padding: const EdgeInsets.all(16),
            ),
            CupertinoTextField(
              controller: contentController,
              placeholder: 'Write your thoughts...',
              padding: const EdgeInsets.all(16),
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How are you feeling?'),
                  CupertinoSlider(
                    value: moodValue,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      moodValue = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                final updatedEntry = JournalEntry(
                  id: entry.id,
                  title: titleController.text,
                  content: contentController.text,
                  timestamp: entry.timestamp,
                  mood: moodValue,
                );
                await AppDataService.instance.updateJournalEntry(updatedEntry);
                if (mounted) {
                  Navigator.pop(context);
                  _loadEntries();
                }
              }
            },
            child: const Text('Save'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getMoodText(double value) {
    if (value <= 1) return 'Terrible';
    if (value <= 2) return 'Bad';
    if (value <= 3) return 'Okay';
    if (value <= 4) return 'Good';
    return 'Great';
  }

  Color _getMoodColor(double value) {
    if (value <= 1) return CupertinoColors.systemRed;
    if (value <= 2) return CupertinoColors.systemOrange;
    if (value <= 3) return CupertinoColors.systemYellow;
    if (value <= 4) return CupertinoColors.systemBlue;
    return CupertinoColors.systemGreen;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Journal'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: _showNewEntrySheet,
        ),
      ),
      child: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
              children: [
                TableCalendar<JournalEntry>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  eventLoader: _getEntriesForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: CupertinoColors.systemRed),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
                Expanded(
                  child: _entriesByDay[_selectedDay]?.isEmpty ?? true
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.book,
                                size: 64,
                                color: CupertinoColors.systemGrey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No entries for ${_formatDate(_selectedDay)}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CupertinoButton(
                                child: const Text('Add an entry'),
                                onPressed: _showNewEntrySheet,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _entriesByDay[_selectedDay]?.length ?? 0,
                          itemBuilder: (context, index) {
                            final entry = _entriesByDay[_selectedDay]![index];
                            return GestureDetector(
                              onTap: () => _showEntryDetails(entry),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CupertinoColors.systemGrey5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            entry.title,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: CupertinoColors.systemGrey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      entry.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.heart_fill,
                                          size: 16,
                                          color: _getMoodColor(entry.mood),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _getMoodText(entry.mood),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _getMoodColor(entry.mood),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
