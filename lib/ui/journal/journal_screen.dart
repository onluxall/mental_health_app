import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';
import 'package:mental_health_app/ui/journal/activity_card.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../get_it_conf.dart';
import '../task/task_card.dart';
import 'journal_bloc/journal_bloc.dart';
import 'journal_list_item.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: BlocProvider<JournalBloc>(
        create: (context) => getIt<JournalBloc>()..add(JournalEventInit()),
        child: BlocBuilder<JournalBloc, JournalState>(builder: (context, state) {
          final dailyEntries =
              state.userJournalEntries.where((entry) => state.chosenDate != null && state.chosenDate!.isSameDayAsTimestamp(entry.date)).toList();
          return Column(
            children: [
              TableCalendar<CalendarEntry>(
                eventLoader: (state.userJournalEntries.isNotEmpty || state.userTasks.isNotEmpty || state.activities.isNotEmpty
                    ? (day) {
                        List<CalendarEntry> allEntries = [];
                        state.userJournalEntries.forEach((journalEntry) {
                          if (day.isSameDayAsTimestamp(journalEntry.date)) {
                            allEntries.add(CalendarEntry(
                                id: journalEntry.id ?? "",
                                type: CalendarEntryType.journalEntry,
                                title: journalEntry.title,
                                content: journalEntry.content,
                                date: journalEntry.date));
                          }
                        });
                        state.activities.forEach((activity) {
                          if (day.isSameDayAsTimestamp(activity.createdAt)) {
                            allEntries.add(
                              CalendarEntry(
                                  id: activity.id ?? "",
                                  type: CalendarEntryType.activity,
                                  title: activity.title,
                                  content: activity.duration,
                                  date: activity.createdAt),
                            );
                          }
                        });
                        state.userTasks.forEach((task) {
                          if (day.isSameDayAsTimestamp(task.date)) {
                            allEntries.add(
                              CalendarEntry(
                                  id: task.id ?? "", type: CalendarEntryType.task, title: task.title, content: task.duration.toString(), date: task.date),
                            );
                          }
                        });
                        return allEntries;
                      }
                    : null),
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: state.chosenDate ?? DateTime.now(),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  context.read<JournalBloc>().add(JournalEventChangeDate(chosenDate: selectedDay));
                },
                selectedDayPredicate: (day) {
                  return isSameDay(state.chosenDate, day);
                },
                daysOfWeekVisible: true,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 20),
                ),
                calendarStyle: CalendarStyle(
                  todayTextStyle: const TextStyle(color: Colors.black),
                  todayDecoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: dailyEntries.isNotEmpty,
                          child: const Text(
                            "Note",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: dailyEntries.length,
                          itemBuilder: (context, index) {
                            final entry = dailyEntries[index];
                            return JournalListItem(
                              journalEntry: entry,
                            );
                          },
                        ),
                        Visibility(
                          visible: state.userTasks.where((task) => state.chosenDate?.isSameDayAsTimestamp(task.date) ?? false).isNotEmpty,
                          child: const Text(
                            "Tasks",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.userTasks.where((task) => state.chosenDate?.isSameDayAsTimestamp(task.date) ?? false).length,
                          itemBuilder: (context, index) {
                            final userTask = state.userTasks.where((task) => state.chosenDate?.isSameDayAsTimestamp(task.date) ?? false).elementAt(index);
                            return TaskCard(
                              onTap: () {},
                              task: userTask,
                            );
                          },
                        ),
                        Visibility(
                          visible: state.activities.where((task) => state.chosenDate?.isSameDayAsTimestamp(task.createdAt) ?? false).isNotEmpty,
                          child: const Text(
                            "Activities",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.activities.where((activity) => state.chosenDate?.isSameDayAsTimestamp(activity.createdAt) ?? false).length,
                          itemBuilder: (context, index) {
                            final activity =
                                state.activities.where((activity) => state.chosenDate?.isSameDayAsTimestamp(activity.createdAt) ?? false).elementAt(index);
                            return ActivityCard(
                              onTap: () {},
                              activity: activity,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class CalendarEntry {
  final String id;
  final CalendarEntryType type;
  final String title;
  final String content;
  final Timestamp date;

  CalendarEntry({required this.id, required this.type, required this.title, required this.content, required this.date});
}

enum CalendarEntryType { activity, task, journalEntry }
