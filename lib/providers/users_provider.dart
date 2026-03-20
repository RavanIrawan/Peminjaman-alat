import 'package:cloud_firestore/cloud_firestore.dart';

class UsersProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot<Object?>> getUsers() async {
    return await _reference.get();
  }

  Future<void> deleteUser(String id) async {
    await _reference.doc(id).delete();
  }
}