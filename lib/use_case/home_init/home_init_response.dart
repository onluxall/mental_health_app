import 'package:mental_health_app/data/user/data.dart';

import '../../data/api_models/quote.dart';
import '../base_use_case_response.dart';

class HomeInitResponse extends BaseUseCaseResponse {
  HomeInitResponse({this.quote, this.user, bool isLoading = false, dynamic error}) : super(isLoading: isLoading, error: error);

  final Quote? quote;
  final UserData? user;
}
