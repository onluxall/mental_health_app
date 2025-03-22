import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../get_it_conf.dart';
import 'data.dart';
import 'interface.dart';

@Injectable(as: IUserRepo)
class UserRepo implements IUserRepo {
  final userCollection = getIt.get<FirebaseFirestore>().collection('user');
  @override
  Future createUser({required String name, required String email, required String id}) {
    final userData = UserData(id: id, name: name, email: email);
    return userCollection.doc(id).set(userData.toJson());
  }
}
