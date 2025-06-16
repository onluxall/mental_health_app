import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/emotion/interface.dart';
import 'package:mental_health_app/extensions/date_time_extension.dart';

import '../../get_it_conf.dart';
import 'data.dart';

@Injectable(as: IEmotionRepo)
class EmotionRepo extends IEmotionRepo {
  final _db = getIt<FirebaseFirestore>().collection('emotionData');

  @override
  Stream<List<EmotionData>> observeEmotionForTodayByUser({required String userId}) async* {
    yield* _db
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: Timestamp.fromMillisecondsSinceEpoch(DateTime.now().atStartOfDay().millisecondsSinceEpoch))
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => EmotionData.fromJson(doc.data())).toList());
  }

  @override
  Future setEmotions({required EmotionData emotion, bool isUpdate = false}) {
    print(isUpdate);
    if (isUpdate) {
      return _db.doc(emotion.id).update({
        'emotionLevel': emotion.emotionLevel.name,
        'emotionsChosen': emotion.emotionsChosen,
      }).catchError((error) {
        print('Error updating emotions: $error');
      });
    } else {
      return _db.add({
        'userId': emotion.userId,
        'emotionLevel': emotion.emotionLevel.name,
        'emotionsChosen': emotion.emotionsChosen,
        'date': Timestamp.fromMillisecondsSinceEpoch(emotion.date.millisecondsSinceEpoch),
      }).then((ref) {
        return ref.update({'id': ref.id});
      }).catchError((error) {
        print('Error setting emotions: $error');
      });
    }
  }
}
