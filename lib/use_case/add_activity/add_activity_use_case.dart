import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/activity/interface.dart';
import 'package:mental_health_app/use_case/base_use_case_response.dart';

import '../../data/activity/data.dart';

abstract class IAddActivityUseCase {
  Stream<BaseUseCaseResponse> invoke({required Activity activity});
}

@Injectable(as: IAddActivityUseCase)
class AddActivityUseCase implements IAddActivityUseCase {
  final IActivityRepo _activityRepository;

  AddActivityUseCase(this._activityRepository);

  @override
  Stream<BaseUseCaseResponse> invoke({required Activity activity}) async* {
    yield BaseUseCaseResponse(isLoading: true);
    try {
      final userId = FirebaseAuth.instance.currentUser;
      await _activityRepository.addActivity(activity: activity.copyWith(userId: userId?.uid));
    } catch (e) {
      yield BaseUseCaseResponse(isLoading: false, error: e);
      return;
    }
    yield BaseUseCaseResponse(isLoading: false);
  }
}
