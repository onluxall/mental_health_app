import 'package:mental_health_app/data/user/data.dart';

abstract class IUserRepo {
  Future createUser({required String name, required String email, required String id});
  Future<UserData?> getUser({required String id});
  Future updateQuizCompleted({required String id, required bool quizCompleted});
}
