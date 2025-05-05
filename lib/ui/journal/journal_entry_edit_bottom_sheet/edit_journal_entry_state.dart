part of 'edit_journal_entry_bloc.dart';

class EditJournalEntryState {
  final String title;
  final String content;
  final bool isLoading;
  final bool navigateBack;
  final dynamic error;

  EditJournalEntryState({
    this.title = '',
    this.content = '',
    this.isLoading = false,
    this.navigateBack = false,
    this.error,
  });

  EditJournalEntryState copyWith({
    String? title,
    String? content,
    bool? isLoading,
    bool? navigateBack,
    dynamic error,
  }) {
    return EditJournalEntryState(
      title: title ?? this.title,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      navigateBack: navigateBack ?? this.navigateBack,
      error: error ?? this.error,
    );
  }
}
