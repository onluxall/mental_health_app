part of 'journal_bloc.dart';

class JournalState extends Equatable {
  final List<JournalEntry> userJournalEntries;
  final List<UserTask> userTasks;
  final List<Activity> activities;
  final DateTime? chosenDate;
  final bool isLoading;
  final dynamic error;

  const JournalState({
    this.userJournalEntries = const [],
    this.userTasks = const [],
    this.activities = const [],
    this.chosenDate,
    this.isLoading = false,
    this.error,
  });

  JournalState copyWith({
    List<JournalEntry>? userJournalEntries,
    List<UserTask>? userTasks,
    List<Activity>? activities,
    DateTime? chosenDate,
    bool? isLoading,
    dynamic error,
  }) {
    return JournalState(
      userJournalEntries: userJournalEntries ?? this.userJournalEntries,
      userTasks: userTasks ?? this.userTasks,
      activities: activities ?? this.activities,
      chosenDate: chosenDate ?? this.chosenDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [userJournalEntries, userTasks, activities, chosenDate, isLoading, error];
}
