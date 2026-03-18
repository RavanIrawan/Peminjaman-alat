import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/models/user_model.dart';
import 'package:peminjaman_alat/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final currentUser = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final authC = Get.find<AuthController>();
  String get userId => authC.user.value!.uid;
  final _provider = Get.find<ProfileProvider>();
  final isGoogleUser = false.obs;

  @override
  void onInit() {
    userLoginMethod();
    getCurrentUser(userId);
    super.onInit();
  }

  void getCurrentUser(String id) async {
    try {
      isLoading.value = true;

      final response = await _provider.getUser(id);

      if (response.exists) {
        final data = response.data() as Map<String, dynamic>;

        final dataUSer = UserModel(
          nama: data['nama'] ?? 'Guest',
          email: data['email'] ?? 'guest@gmail.com',
          role: data['role'] ?? 'Peminjam',
          profile: data['profile'] ?? '',
        );

        currentUser.value = dataUSer;

        isLoading.value = false;
      }else{
        Get.snackbar(
        'gagal',
        'User tidak di temukan, silahkan coba lagi nanti',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar(
        'gagal',
        '$error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  void userLoginMethod() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      for (var provider in currentUser.providerData) {
        if (provider.providerId == 'google.com') {
          isGoogleUser.value = true;
          break;
        }
      }
    }
  }
}
