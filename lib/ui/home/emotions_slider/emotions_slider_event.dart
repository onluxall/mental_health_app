part of 'emotions_slider_bloc.dart';

abstract class EmotionsSliderEvent extends BaseEvent {
  EmotionsSliderEvent({super.isLoading, super.error});
}

class EmotionsSliderEventInit extends EmotionsSliderEvent {
  final EmotionData? emotionData;

  EmotionsSliderEventInit({this.emotionData}) : super(isLoading: false, error: null);
}

class EmotionsSliderEventChangeEmotionLevel extends EmotionsSliderEvent {
  final EmotionLevel level;

  EmotionsSliderEventChangeEmotionLevel({required this.level});
}

class EmotionsSliderEventSwitchEmotion extends EmotionsSliderEvent {
  final String emotion;
  final bool isSelected;

  EmotionsSliderEventSwitchEmotion({required this.emotion, required this.isSelected});
}

class EmotionsSliderEventSave extends EmotionsSliderEvent {}
