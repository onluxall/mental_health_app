part of 'daily_note_bloc.dart';

abstract class DailyNoteEvent extends BaseEvent {}

class DailyNoteEventInit extends DailyNoteEvent {
  final String? id;
  final String? title;
  final String? content;
  DailyNoteEventInit({this.id, this.title, this.content});
}

class UpdateTitleEvent extends DailyNoteEvent {
  final String title;
  UpdateTitleEvent({required this.title});
}

class UpdateContentEvent extends DailyNoteEvent {
  final String content;
  UpdateContentEvent({required this.content});
}

class SubmitEvent extends DailyNoteEvent {
  final BuildContext context;
  SubmitEvent({required this.context});
}

class UpdateEvent extends DailyNoteEvent {}
