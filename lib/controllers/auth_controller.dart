import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/user_model.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';
import 'package:peminjaman_alat/views/general_view/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final isLoading = false.obs;
  Rx<User?> user = Rx<User?>(null);
  late TextEditingController emailC;
  late TextEditingController passC;
  final isObsecureText = false.obs;
  final isObsecureTextPassReg = false.obs;
  final isObsecureTextRegConfirmPass = false.obs;

  FirebaseAuth get auth => _auth;

  late TextEditingController nameReg;
  late TextEditingController emailReg;
  late TextEditingController passReg;

  late TextEditingController emailReset;

  @override
  void onInit() {
    emailC = TextEditingController();
    passC = TextEditingController();

    nameReg = TextEditingController();
    emailReg = TextEditingController();
    passReg = TextEditingController();

    emailReset = TextEditingController();

    user.bindStream(_auth.authStateChanges());

    ever(user, setCurrentView);
    super.onInit();
  }

  void setCurrentView(User? user) async {
    try {
      if (user != null) {
        isLoading.value = true;
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          String role = userDoc['role'] ?? 'Admin';

          if (role == 'Admin') {
            emailC.clear();
            passC.clear();
            Get.offAllNamed('/Admin-view');
          } else if (role == 'Petugas') {
            emailC.clear();
            passC.clear();
            Get.offAllNamed('/Petugas-view');
          } else if (role == 'Peminjam') {
            emailC.clear();
            passC.clear();
            Get.offAllNamed('/Peminjam-view');
          }
        } else {
          isLoading.value = false;
          Get.snackbar(
            'Gagal',
            'User tidak di temukan, silahkan coba lagi nanti',
            backgroundColor: AppColors.error,
            snackPosition: SnackPosition.TOP,
            animationDuration: Duration(milliseconds: 800),
            duration: Duration(seconds: 3),
            icon: Icon(Icons.warning),
            colorText: AppColors.background,
          );
          return;
        }
      } else {
        isLoading.value = false;
        Get.offAll(() => Login());
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Error $error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } finally {
      isLoading.value = false;
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

      if (userDoc.exists && userDoc.data() != null) {
        final emailUser = userDoc.data() as Map<String, dynamic>;
        if (user.user?.email != emailUser['email']) {
          await userDoc.reference.update({'email': user.user?.email});
        }
      } else {
        isLoading.value = false;
        emailC.clear();
        passC.clear();
        Get.snackbar(
          'Gagal',
          'User tidak di temukan, silahkan coba lagi nanti',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
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
      Get.snackbar(
        'Gagal',
        'Terjadi Kesalahan, silahkan coba lagi nanti',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  Future<void> signin(String nama, String email, String password) async {
    isLoading.value = true;
    try {
      final UserCredential currentUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser.user;

      if (user != null) {
        user.updateDisplayName(nama);

        final data = UserModel(nama: nama, email: email, role: 'Peminjam');
        await _firestore.collection('users').doc(user.uid).set(data.toMap());
        Get.toNamed('/Peminjam-view');
        Get.snackbar(
          'Success',
          'Data kamu sudah tersimpan dengan aman. Selamat menikmati kemudahan pinjam-meminjam barang.',
          backgroundColor: AppColors.primary,
          colorText: AppColors.primaryLight,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
        );
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = messageError(e.code);
      Get.snackbar('Gagal', errorMessage);
    } catch (error) {
      Get.snackbar(
        'Terjadi kesalahan',
        'Silahkan coba lagi nanti',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } finally {
      isLoading.value = false;
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

      isLoading.value = true;
      final UserCredential currentUser = await _auth.signInWithCredential(
        credential,
      );

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
            profile: user.photoURL ?? UrlDefaultProfile.url,
          );

          await userDoc.set(newUser.toMap());

          Get.toNamed('/Peminjam-view');
        } else {
          await userDoc.update({'createdAt': FieldValue.serverTimestamp()});

          setCurrentView(user);

          String username = googleUser.displayName ?? 'User';
          Get.snackbar(
            'Selamat Datang kembali $username',
            'Berhasil masuk menggunakan akun Google.',
            backgroundColor: AppColors.primary,
            snackPosition: SnackPosition.TOP,
            animationDuration: Duration(milliseconds: 800),
            duration: Duration(seconds: 3),
            icon: Icon(Icons.check_circle),
            colorText: AppColors.background,
          );
        }
      }
    } catch (error) {
      Get.snackbar(
        'gagal',
        'Terjadi Kesalahan Silahkan Coba lagi nanti',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      for (var provider in currentUser.providerData) {
        if (provider.providerId == 'google.com') {
          await GoogleSignIn().signOut();
        }
      }
    }
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Terjadi kesalahan',
        'Email tidak boleh kosong!',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Berhasil',
        'Link reset password telah dikirim ke email, cek Inbox/Spam',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        e.code,
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan silahkan coba lagi nanti',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
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
