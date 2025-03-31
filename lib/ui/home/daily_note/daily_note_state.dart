part of 'daily_note_bloc.dart';

class DailyNoteState {
  final String? id;
  final String title;
  final String content;
  final bool navigateBack;
  final bool isLoading;
  final String? error;

  const DailyNoteState({
    this.id,
    this.title = '',
    this.content = '',
    this.navigateBack = false,
    this.isLoading = false,
    this.error,
  });

  DailyNoteState copyWith({
    String? id,
    String? title,
    String? content,
    bool? navigateBack,
    bool? isLoading,
    String? error,
  }) {
    return DailyNoteState(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      navigateBack: navigateBack ?? this.navigateBack,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
