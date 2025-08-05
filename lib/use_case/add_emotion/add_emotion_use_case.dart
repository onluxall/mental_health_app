import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/use_case/base_use_case_response.dart';

import '../../data/emotion/data.dart';
import '../../data/emotion/interface.dart';

abstract class IAddEmotionUseCase {
  Stream<BaseUseCaseResponse> invoke({required EmotionData emotion});
}

@Injectable(as: IAddEmotionUseCase)
class AddEmotionUseCase implements IAddEmotionUseCase {
  AddEmotionUseCase(this._emotionRepo);
  final IEmotionRepo _emotionRepo;

  @override
  Stream<BaseUseCaseResponse> invoke({required EmotionData emotion}) async* {
    yield BaseUseCaseResponse(isLoading: true);
    try {
      final userId = FirebaseAuth.instance.currentUser;
      await _emotionRepo.setEmotions(emotion: emotion.copyWith(userId: userId?.uid), isUpdate: emotion.id != null);
    } catch (e) {
      yield BaseUseCaseResponse(isLoading: false, error: e);
      return;
    }
    yield BaseUseCaseResponse(isLoading: false);
  }
}
