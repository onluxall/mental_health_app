import 'package:firebase_auth/firebase_auth.dart';

import '../base_use_case_response.dart';

class SignUpUseCase {
  Stream<BaseUseCaseResponse> invoke({required String email, required String password}) async* {
    try {
      yield BaseUseCaseResponse(isLoading: true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();
      yield BaseUseCaseResponse();
    } catch (e) {
      yield BaseUseCaseResponse(error: e.toString());
    }
  }
}
