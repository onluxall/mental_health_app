part of 'journal_bloc.dart';

abstract class JournalEvent extends BaseEvent {
  JournalEvent({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

class JournalEventInit extends JournalEvent {}

class JournalEventChangeDate extends JournalEvent {
  final DateTime chosenDate;

  JournalEventChangeDate({required this.chosenDate});
}
