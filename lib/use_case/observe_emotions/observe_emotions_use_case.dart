import 'package:injectable/injectable.dart';
import 'package:mental_health_app/use_case/observe_emotions/observe_emotions_response.dart';

import '../../data/emotion/interface.dart';

abstract class IObserveEmotionsUseCase {
  Stream<ObserveEmotionsResponse> invoke({required String userId});
}

@Injectable(as: IObserveEmotionsUseCase)
class ObserveEmotionsUseCase extends IObserveEmotionsUseCase {
  ObserveEmotionsUseCase(this._emotionRepo);

  final IEmotionRepo _emotionRepo;

  @override
  Stream<ObserveEmotionsResponse> invoke({required String userId}) async* {
    yield ObserveEmotionsResponse(isLoading: true);
    try {
      yield* _emotionRepo.observeEmotionForTodayByUser(userId: userId).map((emotions) {
        return ObserveEmotionsResponse(emotions: emotions.firstOrNull);
      });
    } catch (e) {
      yield ObserveEmotionsResponse(error: e.toString());
    }
  }
}
