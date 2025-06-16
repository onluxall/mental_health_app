import 'package:mental_health_app/use_case/base_use_case_response.dart';

import '../../data/emotion/data.dart';

class ObserveEmotionsResponse extends BaseUseCaseResponse {
  ObserveEmotionsResponse({this.emotions, super.isLoading, super.error});

  final EmotionData? emotions;
}
