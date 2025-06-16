import 'package:flutter/material.dart';

class Emotions {
  Emotions._();

  // TODO The lists should be list of enums?
  static List<String> veryLowEmotions = [
    'Sad',
    'Angry',
    'Frustrated',
    'Overwhelmed',
    'Hopeless',
    'Exhausted',
    'Devastated',
    'Despairing',
    'Miserable',
    'Lonely',
    'Terrified',
    'Panicked',
    'Worthless',
    'Guilty',
    'Ashamed',
    'Humiliated',
    'Powerless',
    'Trapped'
  ];

  static List<String> lowEmotions = [
    'Anxious',
    'Tired',
    'Stressed',
    'Disappointed',
    'Worried',
    'Irritable',
    'Nervous',
    'Restless',
    'Uneasy',
    'Tense',
    'Overwhelmed',
    'Confused',
    'Discouraged',
    'Frustrated',
    'Annoyed',
    'Impatient',
    'Insecure',
    'Vulnerable',
    'Exhausted',
    'Drained',
    'Fatigued',
    'Weary'
  ];

  static List<String> neutralEmotions = [
    'Calm',
    'Neutral',
    'Content',
    'Balanced',
    'Peaceful',
    'Relaxed',
    'Stable',
    'Centered',
    'Present',
    'Mindful',
    'Accepting',
    'Patient',
    'Satisfied',
    'Comfortable',
    'Secure',
    'Grounded',
    'Focused',
    'Clear',
    'Tranquil',
    'Serene',
    'At ease',
    'Steady'
  ];

  static List<String> highEmotions = [
    'Happy',
    'Energetic',
    'Motivated',
    'Grateful',
    'Optimistic',
    'Focused',
    'Joyful',
    'Excited',
    'Enthusiastic',
    'Inspired',
    'Confident',
    'Proud',
    'Appreciative',
    'Blessed',
    'Fulfilled',
    'Accomplished',
    'Determined',
    'Driven',
    'Vibrant',
    'Alive',
    'Thriving',
    'Flourishing'
  ];

  static List<String> veryHighEmotions = [
    'Excited',
    'Joyful',
    'Confident',
    'Inspired',
    'Enthusiastic',
    'Empowered',
    'Elated',
    'Ecstatic',
    'Radiant',
    'Blissful',
    'Euphoric',
    'Wonderful',
    'Magnificent',
    'Amazing',
    'Incredible',
    'Fantastic',
    'Brilliant',
    'Spectacular',
    'Triumphant',
    'Victorious',
    'Unstoppable',
    'Invincible'
  ];

  static List<String> getEmotionsByLevel(EmotionLevel level) {
    switch (level) {
      case EmotionLevel.veryLow:
        return veryLowEmotions;
      case EmotionLevel.low:
        return lowEmotions;
      case EmotionLevel.neutral:
        return neutralEmotions;
      case EmotionLevel.high:
        return highEmotions;
      case EmotionLevel.veryHigh:
        return veryHighEmotions;
    }
  }

  static Color getEmotionColor(EmotionLevel level) {
    switch (level) {
      case EmotionLevel.veryLow:
        return Color(0xFF8B0000);
      case EmotionLevel.low:
        return Color(0xFFCC5500);
      case EmotionLevel.neutral:
        return Color(0xFF556B78);
      case EmotionLevel.high:
        return Color(0xFF007C91);
      case EmotionLevel.veryHigh:
        return Color(0xFF046307);
    }
  }

  static double emotionLevelToValue(EmotionLevel level) {
    switch (level) {
      case EmotionLevel.veryLow:
        return 1;
      case EmotionLevel.low:
        return 2;
      case EmotionLevel.neutral:
        return 3;
      case EmotionLevel.high:
        return 4;
      case EmotionLevel.veryHigh:
        return 5;
    }
  }

  static EmotionLevel valueToEmotionLevel(double value) {
    switch (value) {
      case 1:
        return EmotionLevel.veryLow;
      case 2:
        return EmotionLevel.low;
      case 3:
        return EmotionLevel.neutral;
      case 4:
        return EmotionLevel.high;
      case 5:
        return EmotionLevel.veryHigh;
      default:
        throw EmotionLevel.neutral;
    }
  }
}

enum EmotionLevel {
  veryLow,
  low,
  neutral,
  high,
  veryHigh,
}
