import 'package:mental_health_app/use_case/base_use_case_response.dart';

class AuthInitResponse extends BaseUseCaseResponse {
  AuthInitResponse({bool? isLoading, this.isLoggedIn, String? error}) : super(isLoading: isLoading ?? false, error: error);
  final bool? isLoggedIn;
}
