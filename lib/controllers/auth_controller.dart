import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/user_model.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/general_view/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = false.obs;
  final isSignup = false.obs;
  Rx<User?> user = Rx<User?>(null);
  late TextEditingController emailC;
  late TextEditingController passC;
  final isObsecureText = false.obs;

  @override
  void onInit() {
    emailC = TextEditingController();
    passC = TextEditingController();

    user.bindStream(_auth.authStateChanges());

    ever(user, setCurrentView);
    super.onInit();
  }

  void setCurrentView(User? user) async {
    try {
      if (isSignup.value) return;

      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          if (role == 'Admin') {
            Get.offAllNamed('/Admin-view');
          } else if (role == 'Petugas') {
            Get.offAllNamed('/Petugas-view');
          } else if (role == 'Peminjam') {
            Get.offAllNamed('/Peminjam-view');
          }
        }
      } else {
        Get.offAll(() => Login());
      }
    } catch (error) {
      Get.snackbar('gagal', 'User tidak di temukan, silahkan coba lagi nanti');
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final currentUser = user.user?.uid;

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser)
          .get();

      if (userDoc.exists) {
        final role = userDoc['role'];

        if (role == 'Admin') {
          Get.offAllNamed('/Admin-view');
        } else if (role == 'Petugas') {
          Get.offAllNamed('/Petugas-view');
        } else if (role == 'Peminjam') {
          Get.offAllNamed('/Peminjam-view');
        }
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      final errorMessage = messageError(e.code);

      passC.clear();

      Get.snackbar(
        'Terjadi Kesalahan',
        errorMessage,
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,

      );
    } catch (error) {
      isLoading.value = false;
      emailC.clear();
      passC.clear();
      Get.snackbar('Gagal', 'Terjadi Kesalahan, silahkan coba lagi nanti');
    }
  }

  Future<void> signin(String nama, String email, String password) async {
    try {
      isSignup.value = true;
      final UserCredential currentUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser.user;

      if (user != null) {
        user.updateDisplayName(nama);

        final data = UserModel(nama: nama, email: email, role: 'Peminjam');
        await _firestore.collection('users').doc(user.uid).set(data.toMap());
      }
      Get.back();
      Get.snackbar(
        'Success',
        'Silahkan melakukan verifikasi email yang sudah kami kirim. check mailbox/spam',
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = messageError(e.code);
      Get.snackbar('Gagal', errorMessage);
    } catch (error) {
      Get.snackbar('Terjadi kesalahan', 'Silahkan coba lagi nanti');
    }
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = true;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential currentUser = await _auth.signInWithCredential(
        credential,
      );

      isLoading.value = true;

      final User? user = currentUser.user;

      if (user != null) {
        final DocumentReference userDoc = _firestore
            .collection('users')
            .doc(user.uid);

        final snapshot = await userDoc.get();

        if (!snapshot.exists) {
          final newUser = UserModel(
            id: user.uid,
            nama: user.displayName ?? 'unknow',
            email: user.email ?? 'Test@gmail.com',
            role: 'Peminjam',
          );

          await userDoc.set(newUser.toMap());
        } else {
          await userDoc.update({'createdAt': FieldValue.serverTimestamp()});
          Get.snackbar('Welcome Back', 'Berhasil melakukan Login');
        }
      }
    } catch (error) {
      Get.snackbar('gagal', 'Terjadi Kesalahan Silahkan Coba lagi nanti');
    } finally {
      isLoading.value = false;
    }
  }

  String messageError(String message) {
    switch (message) {
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Silakan login saja.';
      case 'invalid-email':
        return 'Format email tidak valid. Cek lagi ya.';
      case 'operation-not-allowed':
        return 'Metode login ini sedang dinonaktifkan.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'user-not-found':
        return 'Email tidak ditemukan. Silakan daftar dulu.';
      case 'wrong-password':
        return 'Password salah. Coba ingat-ingat lagi.';
      case 'invalid-credential':
        return 'Email atau Password salah.';
      default:
        return 'Terjadi kesalahan: $message';
    }
  }
}
