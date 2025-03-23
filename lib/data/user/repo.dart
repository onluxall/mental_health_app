import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'data.dart';
import 'interface.dart';

@Injectable(as: IUserRepo)
class UserRepo implements IUserRepo {
  final userCollection = FirebaseFirestore.instance.collection('user');
  @override
  Future createUser({required String name, required String email, required String id}) {
    final userData = UserData(id: id, name: name, email: email);
    return userCollection.doc(id).set(userData.toJson());
  }

  @override
  Future<UserData?> getUser({required String id}) async {
    final snapshot = await userCollection.doc(id).get();
    if (snapshot.data() == null) {
      return null;
    } else {
      return UserData.fromJson(snapshot.data()!);
    }
  }
}
