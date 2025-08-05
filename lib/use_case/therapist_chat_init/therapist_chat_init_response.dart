import 'package:mental_health_app/data/chat/data.dart';

import '../base_use_case_response.dart';

class TherapistInitResponse extends BaseUseCaseResponse {
  TherapistInitResponse({
    this.chats = const [],
    super.isLoading,
    super.error,
  });

  final List<ChatHistory> chats;
}
