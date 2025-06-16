import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_app/ui/home/emotions_slider/emotions_slider_bloc.dart';

import '../../../data/emotion/data.dart';
import '../../../data/emotion/emotions.dart';
import '../../../get_it_conf.dart';

// TODO Make slider more stable and make the emotions "stay" in same place when changing the slider value or at least make the content below not move
class EmotionsSliderWidget extends StatelessWidget {
  const EmotionsSliderWidget({this.initialEmotionData, super.key});
  final EmotionData? initialEmotionData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmotionsSliderBloc>(
      create: (context) => getIt<EmotionsSliderBloc>()..add(EmotionsSliderEventInit(emotionData: initialEmotionData)),
      child: BlocBuilder<EmotionsSliderBloc, EmotionsSliderState>(builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      context.read<EmotionsSliderBloc>().add(EmotionsSliderEventSave());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                value: Emotions.emotionLevelToValue(state.emotionLevel ?? EmotionLevel.neutral),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (newValue) {
                  context.read<EmotionsSliderBloc>().add(
                        EmotionsSliderEventChangeEmotionLevel(level: Emotions.valueToEmotionLevel(newValue)),
                      );
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Not well',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Great',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: Emotions.getEmotionsByLevel(state.emotionLevel ?? EmotionLevel.neutral).map((emotion) {
                  final bool isSelected = state.emotionsChosen?.contains(emotion) ?? false;
                  return GestureDetector(
                    onTap: () {
                      context.read<EmotionsSliderBloc>().add(EmotionsSliderEventSwitchEmotion(emotion: emotion, isSelected: !isSelected));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Emotions.getEmotionColor(state.emotionLevel ?? EmotionLevel.neutral) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Emotions.getEmotionColor(state.emotionLevel ?? EmotionLevel.neutral),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        emotion,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Emotions.getEmotionColor(state.emotionLevel ?? EmotionLevel.neutral),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
