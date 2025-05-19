import 'data.dart';

abstract class IActivityRepo {
  Stream<List<Activity>> getActivitiesByUser({required String userId});
  Future<Activity> getActivityById({required String id});
  Future<void> addActivity({required Activity activity});
}
