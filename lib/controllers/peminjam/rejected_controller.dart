import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/providers/peminjam/rejected_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class RejectedController extends GetxController {
  final _provider = Get.find<RejectedProvider>();
  final pinjamanC = Get.find<PinjamanController>();
  final isLoading = false.obs;

  Future<void> deleteProduct(String id) async {
    final indexData = pinjamanC.dataPeminjamanDitolak.indexWhere(
      (element) => element.id == id,
    );

    if (indexData != -1) {
      bool dialogCancel = await Get.defaultDialog(
        backgroundColor: AppColors.surface,
        titlePadding: EdgeInsets.zero,
        title: '',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/deleteIconAnimation.json',
              height: 90,
              fit: BoxFit.cover,
              repeat: false,
            ),
            SizedBox(height: 10),
            Text(
              'Hapus Data?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Apakah Anda yakin ingin menghapus data ini? Tindakan ini dapat dibatalkan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
                fontSize: 13,
              ),
            ),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(result: true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text('Hapus'),
        ),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back(result: false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text('Batal'),
        ),
      );

      if (dialogCancel != true) return;
      isLoading.value = true;
      pinjamanC.dataPeminjamanDitolak.removeAt(indexData);

      try {
        await _provider.deleteProductRejected(id);
      } catch (error) {
        Get.snackbar(
          'Error',
          'Error: $error',
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
    } else {
      Get.snackbar(
        'Error',
        'Data Tidak ditemukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }
}
