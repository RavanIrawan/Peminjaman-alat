import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_product_controller.dart';
import 'package:peminjaman_alat/models/alat_model.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class DetailAlatViewController extends GetxController {
  String productId = Get.arguments as String;
  final _prodC = Get.find<HomePeminjamanProductController>();
  Rx<AlatModel?> detailProd = Rx<AlatModel?>(null);
  final qty = 0.obs;
  final durasi = [1, 2, 3, 4, 5, 6, 7];
  Rx<int?> selectedDuration = Rx<int?>(3);
  final now = DateTime.now().obs;

  get tenggatWaktu => now.value.add(Duration(days: selectedDuration.value!));

  @override
  void onInit() {
    if (productId.isNotEmpty) {
      detailProd = _prodC.alat
          .firstWhere((element) => element.id == productId)
          .obs;
    }
    super.onInit();
  }

  void addQty() {
    final indexAlat = _prodC.alat.indexWhere(
      (element) => element.id == productId,
    );
    if (indexAlat != -1) {
      if (qty >= _prodC.alat[indexAlat].stok!) {
        Get.snackbar(
          'Stok Terbatas',
          'Kamu sudah mencapai batas maksimal stok yang tersedia',
          backgroundColor: AppColors.warning,
          snackPosition: SnackPosition.TOP,
          animationDuration: const Duration(milliseconds: 800),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning_amber_rounded),
          colorText: AppColors.background,
        );
      } else {
        qty.value++;
      }
    }
  }

  void kurangQty() {
    if (qty.value > 0) {
      qty.value--;
    }
  }
}
