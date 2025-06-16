part of 'emotions_slider_bloc.dart';

class EmotionsSliderState {
  final EmotionLevel? emotionLevel;
  final List<String>? emotionsChosen;
  final bool isLoading;
  final String? error;
  final EmotionData? initialEmotionData;

  EmotionsSliderState({
    this.emotionLevel,
    this.emotionsChosen,
    this.initialEmotionData,
    this.isLoading = false,
    this.error,
  });

  EmotionsSliderState copyWith({
    EmotionLevel? emotionLevel,
    List<String>? emotionsChosen,
    EmotionData? initialEmotionData,
    bool? isLoading,
    String? error,
  }) {
    return EmotionsSliderState(
      emotionLevel: emotionLevel ?? this.emotionLevel,
      emotionsChosen: emotionsChosen ?? this.emotionsChosen,
      initialEmotionData: initialEmotionData ?? this.initialEmotionData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
