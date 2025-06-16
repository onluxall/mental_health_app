part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Quote? quote;
  final UserData? user;
  final JournalEntry? todayJournalEntry;
  final EmotionData? todayEmotionData;
  final bool isLoading;
  final dynamic error;

  const HomeState({
    this.quote,
    this.user,
    this.todayJournalEntry,
    this.todayEmotionData,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [quote, user, todayJournalEntry, todayEmotionData, isLoading, error];
}
