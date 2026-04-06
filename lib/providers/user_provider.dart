import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<DocumentSnapshot<Object?>> getUser(String id) async {
    try {
      return await _reference.doc(id).get();
    } catch (error) {
      throw Exception('Gagal mengambil data profil: $error');
    }
  }
}
