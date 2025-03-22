import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/use_case/auth_init/auth_init_response.dart';

abstract class IAuthInitUseCase {
  Stream<AuthInitResponse> invoke();
}

@Injectable(as: IAuthInitUseCase)
class AuthInitUseCase extends IAuthInitUseCase {
  AuthInitUseCase(this._authRepo);

  final FirebaseAuth _authRepo;
  @override
  Stream<AuthInitResponse> invoke() async* {
    try {
      yield AuthInitResponse(isLoading: true);
      final isLoggedIn = _authRepo.currentUser != null && _authRepo.currentUser!.emailVerified;
      yield AuthInitResponse(isLoading: false, isLoggedIn: isLoggedIn);
    } catch (e) {
      yield AuthInitResponse(error: e.toString());
    }
  }
}
