import 'data.dart';

abstract class IEmotionRepo {
  Stream<List<EmotionData>> observeEmotionForTodayByUser({required String userId});
  Future setEmotions({required EmotionData emotion, bool isUpdate = false});
}
