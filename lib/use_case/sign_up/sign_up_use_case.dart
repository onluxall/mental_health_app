import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mental_health_app/data/user/interface.dart';

import '../base_use_case_response.dart';

abstract class ISignUpUseCase {
  Stream<BaseUseCaseResponse> invoke({required String email, required String password});
}

@Injectable(as: ISignUpUseCase)
class SignUpUseCase extends ISignUpUseCase {
  SignUpUseCase(this._userRepo);

  final IUserRepo _userRepo;
  @override
  Stream<BaseUseCaseResponse> invoke({required String email, required String password}) async* {
    try {
      yield BaseUseCaseResponse(isLoading: true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await _userRepo.createUser(name: email, email: email, id: FirebaseAuth.instance.currentUser?.uid ?? "");
      await FirebaseAuth.instance.signOut();
      yield BaseUseCaseResponse();
    } catch (e) {
      yield BaseUseCaseResponse(error: e.toString());
    }
  }
}
