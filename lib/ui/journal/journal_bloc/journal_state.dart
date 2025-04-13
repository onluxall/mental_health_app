part of 'journal_bloc.dart';

class JournalState extends Equatable {
  final List<JournalEntry> userJournalEntries;
  final List<JournalEntry> presentedJournalEntries;
  final DateTime? chosenDate;
  final bool isLoading;
  final dynamic error;

  const JournalState({
    this.userJournalEntries = const [],
    this.presentedJournalEntries = const [],
    this.chosenDate,
    this.isLoading = false,
    this.error,
  });

  JournalState copyWith({
    List<JournalEntry>? userJournalEntries,
    List<JournalEntry>? presentedJournalEntries,
    DateTime? chosenDate,
    bool? isLoading,
    dynamic error,
  }) {
    return JournalState(
      userJournalEntries: userJournalEntries ?? this.userJournalEntries,
      presentedJournalEntries: presentedJournalEntries ?? this.presentedJournalEntries,
      chosenDate: chosenDate ?? this.chosenDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [userJournalEntries, chosenDate, isLoading, error];
}
