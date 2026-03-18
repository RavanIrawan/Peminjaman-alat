import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/user_model.dart';

class EditProfileProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> updateUserInfo(
    String id,
    String? path,
    String nama,
    String? email,
    String role
  ) async {
    final data = UserModel(nama: nama, email: email!, profile: path, role: role);

    await _reference.doc(id).update(data.toMap());
  }
}
