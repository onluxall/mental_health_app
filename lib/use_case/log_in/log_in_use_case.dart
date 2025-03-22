import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/use_case/base_use_case_response.dart';

abstract class ILogInUseCase {
  Stream<BaseUseCaseResponse> invoke({required String email, required String password});
}

@Injectable(as: ILogInUseCase)
class LogInUseCase extends ILogInUseCase {
  @override
  Stream<BaseUseCaseResponse> invoke({required String email, required String password}) async* {
    try {
      yield BaseUseCaseResponse(isLoading: true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      yield BaseUseCaseResponse();
    } catch (e) {
      yield BaseUseCaseResponse(error: e.toString());
    }
  }
}
