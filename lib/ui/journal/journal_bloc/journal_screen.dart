import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../get_it_conf.dart';
import '../journal_list_item.dart';
import 'journal_bloc.dart';

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
              TableCalendar(
                eventLoader: (state.userJournalEntries.isNotEmpty
                    ? (day) {
                        return state.userJournalEntries.where((entry) => day.isSameDayAsTimestamp(entry.date)).toList();
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
                child: ListView.builder(
                  itemCount: dailyEntries.length,
                  itemBuilder: (context, index) {
                    final entry = dailyEntries[index];
                    return JournalListItem(
                      journalEntry: entry,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
