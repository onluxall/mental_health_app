abstract class IUserRepo {
  Future createUser({required String name, required String email, required String id});
}
