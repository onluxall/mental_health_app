part of 'edit_journal_entry_bloc.dart';

abstract class EditJournalEntryEvent extends BaseEvent {
  EditJournalEntryEvent({bool? isLoading, dynamic error}) : super(isLoading: isLoading, error: error);
}

class EditJournalEntryEventInit extends EditJournalEntryEvent {
  final String title;
  final String content;

  EditJournalEntryEventInit({required this.title, required this.content});
}

class EditJournalEntryEventUpdateTitle extends EditJournalEntryEvent {
  final String title;
  EditJournalEntryEventUpdateTitle({required this.title});
}

class EditJournalEntryEventUpdateContent extends EditJournalEntryEvent {
  final String content;

  EditJournalEntryEventUpdateContent({required this.content});
}

class EditJournalEntryEventSaveEntry extends EditJournalEntryEvent {
  final String id;

  EditJournalEntryEventSaveEntry({required this.id});
}
