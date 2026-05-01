import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:peminjaman_alat/providers/edit_profile_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileController extends GetxController {
  final nameText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final newEmailText = TextEditingController();
  final phone = TextEditingController();
  final _getConnect = GetConnect();
  final _imagePicker = ImagePicker();
  final isUploading = false.obs;
  final isEditEmail = false.obs;
  final isLoading = false.obs;
  final authC = Get.find<AuthController>();
  final _provider = Get.find<EditProfileProvider>();
  Rx<File?> imageFile = Rx<File?>(null);

  @override
  void onInit() {
    nameText.text = authC.userWithModel.value?.nama ?? 'Guest';
    emailText.text = authC.userWithModel.value?.email ?? 'Geust@gmail.com';
    phone.text = authC.userWithModel.value?.phone ?? '0';

    super.onInit();
  }

  @override
  void onClose() {
    nameText.dispose();
    emailText.dispose();
    newEmailText.dispose();
    passwordText.dispose();
    phone.dispose();
    imageFile.value = null;

    super.onClose();
  }

  Future<void> pickImageFromGallery() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
    }
  }

  Future<String?> uploadIMageToCloudinary() async {
    if (imageFile.value == null) return null;

    isUploading.value = true;
    try {
      String cloudinaryName = 'CLOUDINARY_NAME';
      String cloudinaryUploadPreset = 'PRESET_NAME';

      String url =
          "https://api.cloudinary.com/v1_1/$cloudinaryName/image/upload";

      final formData = FormData({
        'file': MultipartFile(
          imageFile.value!.path,
          filename: imageFile.value!.path.split('/').last,
        ),
        'upload_preset': cloudinaryUploadPreset,
      });

      final response = await _getConnect.post(url, formData);

      if (response.hasError) {
        Get.snackbar(
          'gagal',
          'Terjadi kesalahan saat meng-upload gambar',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );

        return null;
      } else {
        String imageUrl = response.body['secure_url'];
        return imageUrl;
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Sistem bermasalah $error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );

      return null;
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> editProfile() async {
    isLoading.value = true;
    try {
      final pickedImageurl = await uploadIMageToCloudinary();

      final String? finalImageUrl =
          pickedImageurl ?? authC.userWithModel.value?.profile;

      final id = authC.userWithModel.value?.id;

      authC.userWithModel.value?.phone = phone.text;
      authC.userWithModel.value?.nama = nameText.text;

      await _provider.updateUserInfo(
        id!,
        finalImageUrl,
        nameText.text,
        emailText.text,
        authC.userWithModel.value?.role ?? 'Peminjam',
        phone.text,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Sistem bermasalah $error',
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

  Future<void> changeEmail() async {
    try {
      isLoading.value = true;

      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final emailLama = currentUser.email!;
        final passwordLama = passwordText.text.trim();
        final emailBaru = newEmailText.text.trim();

        final credential = EmailAuthProvider.credential(
          email: emailLama,
          password: passwordLama,
        );

        await currentUser.reauthenticateWithCredential(credential);

        await currentUser.verifyBeforeUpdateEmail(emailBaru);
        Get.snackbar(
          'Email Verifikasi Terkirim',
          'Silahkan periksa kotak masuk (inbox) atau spam di email BARU kamu untuk mengonfirmasi perubahan. Setelah diklik, silakan login ulang.',
          backgroundColor: AppColors.primary,
          colorText: AppColors.surface,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 5),
          icon: Icon(Icons.mark_email_unread),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Get.snackbar(
          'Gagal',
          'Password lama yang kamu masukkan salah.',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Gagal',
          'Email baru ini sudah terdaftar di akun lain.',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      } else {
        Get.snackbar(
          'Error',
          e.message ?? 'Terjadi kesalahan.',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan Sistem',
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
}
