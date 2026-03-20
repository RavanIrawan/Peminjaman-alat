import 'package:get/get.dart';
import 'package:peminjaman_alat/providers/dashboard_admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class HomeAdminController extends GetxController {
  final userCountData = 0.obs;
  final isLoading = false.obs;
  final _provider = Get.find<DashboardAdminProvider>();

  @override
  void onInit() {
    getDataCountUser();
    super.onInit();
  }

  Future<void> getDataCountUser() async {
    isLoading.value = true;
    try{
      final userCount = await _provider.getUserLength();

      userCountData.value = userCount;
    }catch(error){
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan $error',
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