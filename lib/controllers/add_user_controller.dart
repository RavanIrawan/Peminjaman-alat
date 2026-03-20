import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/users_controller.dart';
import 'package:peminjaman_alat/providers/add_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peminjaman_alat/utils/saved_data_dialog.dart';

class AddUserController extends GetxController {
  TextEditingController emailText = TextEditingController();
  TextEditingController passText = TextEditingController();
  TextEditingController namaText = TextEditingController();
  final _provider = Get.find<AddUserProvider>();
  final _auth = Get.find<AuthController>();
  final isLoading = false.obs;
  final isObsecureText = false.obs;
  RxString selectedRole = 'Petugas'.obs;
  final listRole = ['Admin', 'Petugas', 'Peminjam'];
  String? idUserEdit = Get.arguments as String?;
  final isEditMode = false.obs;
  late String? profileUserEdit;

  String? get userId => _auth.user.value?.uid;

  @override
  void onInit() {
    if (idUserEdit != null) {
      isEditMode.value = true;
      final userC = Get.find<UsersController>();

      final usersEdit = userC.users.firstWhere(
        (element) => element.id == idUserEdit,
      );

      namaText.text = usersEdit.nama!;
      emailText.text = usersEdit.email!;
      selectedRole.value = usersEdit.role!;
      profileUserEdit = usersEdit.profile!;
    }
    super.onInit();
  }

  @override
  void onClose() {
    emailText.dispose();
    passText.dispose();
    namaText.dispose();

    super.onClose();
  }

  Future<void> updateUser() async {
    isLoading.value = true;
    try {
      await _provider.editUser(idUserEdit!, namaText.text, selectedRole.value, emailText.text, 0, profileUserEdit!);
      Get.back();
      Get.snackbar(
        'Success',
        'Data user berhasil di update',
        backgroundColor: AppColors.primary,
        colorText: AppColors.primaryLight,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
      );
    } catch (error) {
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

  Future<void> addUser(String email, String password, String nama) async {
    if (email.isEmpty || password.isEmpty || nama.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Semua kolom wajib diisi!',
        backgroundColor: AppColors.error,
        colorText: AppColors.background,
      );
      return;
    }
    isLoading.value = true;
    try {
      await _provider.addNewUser(email, password, nama, selectedRole.value);

      emailText.clear();
      passText.clear();
      namaText.clear();

      SavedDataDialog().showSavedDataDialog(
        'Data Tersimpan!',
        'Data user baru berhasil ditambahkan ke dalam sistem',
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = messageError(e.code);

      Get.snackbar(
        'Gagal',
        'Error $errorMessage',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
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
