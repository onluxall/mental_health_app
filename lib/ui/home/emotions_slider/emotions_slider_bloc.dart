import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';
import 'package:mental_health_app/use_case/add_emotion/add_emotion_use_case.dart';

import '../../../data/emotion/data.dart';
import '../../../data/emotion/emotions.dart';
import '../../base/base_event.dart';

part 'emotions_slider_event.dart';
part 'emotions_slider_state.dart';

@Injectable()
class EmotionsSliderBloc extends Bloc<EmotionsSliderEvent, EmotionsSliderState> {
  EmotionsSliderBloc(this._addEmotionUseCase) : super(EmotionsSliderState()) {
    on<EmotionsSliderEventInit>(_onEmotionsSliderEventInit);
    on<EmotionsSliderEventChangeEmotionLevel>(_onEmotionsSliderEventChangeEmotionValue);
    on<EmotionsSliderEventSwitchEmotion>(_onEmotionsSliderEventSwitchEmotion);
    on<EmotionsSliderEventSave>(_onEmotionsSliderEventSave);
  }

  final IAddEmotionUseCase _addEmotionUseCase;

  Future<void> _onEmotionsSliderEventInit(
    EmotionsSliderEventInit event,
    Emitter<EmotionsSliderState> emit,
  ) async {
    return emit(
      state.copyWith(
        initialEmotionData: event.emotionData,
        emotionLevel: event.emotionData?.emotionLevel ?? EmotionLevel.neutral,
        emotionsChosen: event.emotionData?.emotionsChosen ?? [],
      ),
    );
  }

  Future<void> _onEmotionsSliderEventChangeEmotionValue(
    EmotionsSliderEventChangeEmotionLevel event,
    Emitter<EmotionsSliderState> emit,
  ) async {
    return emit(
      state.copyWith(
        initialEmotionData: state.initialEmotionData,
        emotionLevel: event.level,
        emotionsChosen: [],
      ),
    );
  }

  Future<void> _onEmotionsSliderEventSwitchEmotion(
    EmotionsSliderEventSwitchEmotion event,
    Emitter<EmotionsSliderState> emit,
  ) async {
    final emotionsChosen = List<String>.from(state.emotionsChosen ?? []);
    if (event.isSelected) {
      emotionsChosen.add(event.emotion);
    } else {
      emotionsChosen.remove(event.emotion);
    }
    return emit(
      state.copyWith(
        initialEmotionData: state.initialEmotionData,
        emotionsChosen: emotionsChosen,
      ),
    );
  }

  Future<void> _onEmotionsSliderEventSave(
    EmotionsSliderEventSave event,
    Emitter<EmotionsSliderState> emit,
  ) async {
    return emit.forEach(
      _addEmotionUseCase.invoke(
          emotion: EmotionData(
              id: state.initialEmotionData?.id,
              userId: state.initialEmotionData?.userId,
              emotionLevel: state.emotionLevel ?? EmotionLevel.neutral,
              emotionsChosen: state.emotionsChosen ?? [],
              date: Timestamp.fromMillisecondsSinceEpoch(DateTime.now().atStartOfDay().millisecondsSinceEpoch))),
      onData: (result) {
        if (result.isSuccessful()) {
          return state.copyWith(
            isLoading: false,
            error: null,
          );
        } else {
          return state.copyWith(
            isLoading: false,
            error: result.error,
          );
        }
      },
    );
  }
}
