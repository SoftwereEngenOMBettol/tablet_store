import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/app_user.dart';

class UserRepository {
  UserRepository({FirebaseFirestore? firestore})
      : _users = (firestore ?? FirebaseFirestore.instance)
            .collection(FirestorePaths.users);

  final CollectionReference<Map<String, dynamic>> _users;

  Future<void> createUser(AppUser user) => _users.doc(user.uid).set(user.toMap());

  Future<AppUser?> getUser(String uid) async {
    final data = (await _users.doc(uid).get()).data();
    return data == null ? null : AppUser.fromMap(data, uid);
  }
}
