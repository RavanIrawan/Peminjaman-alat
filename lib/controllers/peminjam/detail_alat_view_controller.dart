import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_product_controller.dart';
import 'package:peminjaman_alat/models/alat_model.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class DetailAlatViewController extends GetxController {
  String productId = Get.arguments as String;
  final authC = Get.find<AuthController>();
  final _prodC = Get.find<HomePeminjamanProductController>();
  Rx<AlatModel?> detailProd = Rx<AlatModel?>(null);
  final qty = 0.obs;
  final durasi = [1, 2, 3, 4, 5, 6, 7];
  Rx<int?> selectedDuration = Rx<int?>(3);

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

  void tampilkanDialogLengkapiProfil() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1), 
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.contact_phone_outlined, 
                  color: AppColors.primary, 
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Lengkapi Profil Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Inter', 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              Text(
                'Sistem mendeteksi Anda belum mendaftarkan nomor telepon. Silakan perbarui profil Anda terlebih dahulu agar dapat meminjam alat.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5, 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(), 
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Nanti Saja',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0, 
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), 
                        ),
                      ),
                      child: const Text(
                        'Update Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
