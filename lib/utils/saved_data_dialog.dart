import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class SavedDataDialog {
  void showSavedDataDialog(String title, String text, bool trans) {
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: AppColors.surface,
      title: '',
      titlePadding: EdgeInsets.zero,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            trans
                ? 'assets/lotties/successTransactionUser.json'
                : 'assets/lotties/success.json',
            height: 100,
            fit: BoxFit.cover,
            repeat: false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        trans
            ? Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory),
                        SizedBox(width: 5),
                        Text(
                          'Lihat Barang Saya',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            wordSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      final tabPage = Get.find<HomePeminjamanController>();

                      tabPage.changeTabIndex(0);
                      Get.until((route) => route.settings.name == '/Peminjam-view',);
                    },
                    child: Text(
                      'Kembali Ke Beranda',
                      style: TextStyle(color: AppColors.primary, fontSize: 13),
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Oke, Lanjut',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
