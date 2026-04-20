import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:peminjaman_alat/models/user_model.dart';

class AddUserProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> addNewUser(
    String email,
    String password,
    String nama,
    String role,
    String phone
  ) async {
    FirebaseApp mainApp = Firebase.app();
    FirebaseOptions appOption = mainApp.options;

    final backApp = await Firebase.initializeApp(
      name: 'AppOption',
      options: appOption,
    );
    try {
      FirebaseAuth secondApp = FirebaseAuth.instanceFor(app: backApp);

      UserCredential newUser = await secondApp.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUserUid = newUser.user!.uid;
      await newUser.user!.updateDisplayName(nama);

      final data = UserModel(nama: nama, email: email, role: role, phone: phone);

      await _reference.doc(newUserUid).set(data.toMap());
    } finally {
      await backApp.delete();
    }
  }

  Future<void> editUser(
    String id,
    String nama,
    String role,
    String email,
    String phone,
    String profile
  ) async {
    final data = UserModel(
      nama: nama,
      role: role,
      email: email,
      phone: phone,
      profile: profile
    );

    await _reference.doc(id).update(data.toMap());
  }
}
