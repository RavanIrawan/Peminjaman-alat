import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/petugas/persetujuan_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class PersetujuanController extends GetxController {
  final isLoading = false.obs;
  final petugasC = Get.find<PetugasController>();
  final _provider = Get.find<PersetujuanProvider>();
  final _authC = Get.find<AuthController>();
  final textPenolakan = ''.obs;

  @override
  void onClose() {
    textPenolakan.value = '';
    super.onClose();
  }

  Future<void> acceptPeminjamanProduct(String id, int durasi, PeminjamanModel data) async {
    isLoading.value = true;
    final tanggalPinjam = DateTime.now();
    final tenggatWaktu = tanggalPinjam.add(Duration(days: durasi));

    try {
      await _provider.acceptPeminjaman(
        id,
        Timestamp.fromDate(tanggalPinjam),
        Timestamp.fromDate(tenggatWaktu),
        data,
        _authC.userWithModel.value?.id ?? '',
        _authC.userWithModel.value?.nama ?? '',
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error: data barang tidak di temukan.',
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

  Future<void> rejectPeminjaman(String id, String alasan) async {
    if(textPenolakan.isEmpty) {
      Get.snackbar(
        'Error',
        'Field Penolakan Wajib Di Isi!',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }

    isLoading.value = true;
    final now = DateTime.now();
    final tglDiTolak = Timestamp.fromDate(now);
    final indexData = petugasC.allData.indexWhere(
      (element) => element.id == id,
    );
    final indexDataPersetujuan = petugasC.allDataPersetujuan.indexWhere(
      (element) => element.id == id,
    );

    if (indexData != -1) {
      petugasC.allData[indexData].status = 'di_tolak';

      if (indexDataPersetujuan != -1) {
        petugasC.allDataPersetujuan[indexDataPersetujuan].status = 'di_tolak';
      } else {
        Get.snackbar(
          'Error',
          'Error: Data Barang Tidak Ditemukan',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      }

      try {
        await _provider.rejectPeminjaman(id, tglDiTolak, alasan);
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
        'Error: Data Tidak Ditemukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  void showBottomSheetsForReject(String id) {
    Get.bottomSheet(
      isScrollControlled: true,
      enterBottomSheetDuration: Duration(milliseconds: 400),
      exitBottomSheetDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          height: 500,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alasan Penolakan',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Beri tahu peminjam mengapa pengajuan ini tidak dapat disetujui. Pesan ini akan dikirimkan secara otomatis",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Detail Alasan'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        maxLines: 4,
                        onChanged: (value) {
                          textPenolakan.value = value;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.textSecondary.withValues(
                            alpha: 0.1,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                          hintText:
                              'Contoh: Alat sedang dalam tahap pemeliharaan rutin atau ketersediaan stok sedang terbatas...',
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                rejectPeminjaman(id, textPenolakan.value);
                                textPenolakan.value = '';
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Kirim Penolakan',
                                style: TextStyle(
                                  color: AppColors.surface,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
