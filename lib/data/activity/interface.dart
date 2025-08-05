import 'data.dart';

abstract class IActivityRepo {
  Stream<List<Activity>> getActivitiesByUser({required String userId});
  Future addActivity({required Activity activity});
}
