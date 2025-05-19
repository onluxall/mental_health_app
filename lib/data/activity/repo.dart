import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'data.dart';
import 'interface.dart';

@Injectable(as: IActivityRepo)
class ActivityRepo implements IActivityRepo {
  final _activityDB = FirebaseFirestore.instance.collection('activity');
  @override
  Stream<List<Activity>> getActivitiesByUser({required String userId}) async* {
    yield* _activityDB.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Activity.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Future addActivity({required Activity activity}) {
    return _activityDB.add(activity.toJson()).then((value) {}).catchError((error) {
      throw Exception('Failed to add activity: $error');
    });
  }

  @override
  Future<Activity> getActivityById({required String id}) {
    // TODO: implement getActivityById
    throw UnimplementedError();
  }
}
