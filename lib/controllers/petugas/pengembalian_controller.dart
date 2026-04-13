import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';
import 'package:peminjaman_alat/providers/petugas/pengembalian_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/convert_to_rupiah.dart';

class PengembalianController extends GetxController {
  final _provider = Get.find<PengembalianProvider>();
  final petugasC = Get.find<PetugasController>();
  final _authC = Get.find<AuthController>();
  final isLoading = false.obs;
  final now = DateTime.now();

  int get totalDipinjam {
    final data = petugasC.allDataDiPinjam
        .where((element) => element.status == 'diPinjam')
        .toList();

    return data.length;
  }

  int? get totalterlambat {
    final now = DateTime.now();
    final hariIniAja = DateTime(now.year, now.month, now.day);
    final data = petugasC.allDataDiPinjam.where((element) {
      if (element.tenggatWaktu == null) return false;

      final tenggatAja = DateTime(
        element.tenggatWaktu!.year,
        element.tenggatWaktu!.month,
        element.tenggatWaktu!.day,
      );

      return hariIniAja.isAfter(tenggatAja);
    }).toList();

    return data.length;
  }

  int countTheDaysLate(DateTime tenggat) {
    final now = DateTime.now();
    final nowWithNoTime = DateTime(now.year, now.month, now.day);
    final tenggatWithNoTime = DateTime(
      tenggat.year,
      tenggat.month,
      tenggat.day,
    );

    final terlambat = nowWithNoTime.difference(tenggatWithNoTime);

    return terlambat.inDays;
  }

  Future<void> returnProductWithStatusCompleted(
    String id,
    DateTime tanggalKembali,
    DateTime tenggatWaktu,
  ) async {
    isLoading.value = true;
    final fineAmount = countMonetaryFine(tanggalKembali, tenggatWaktu);
    final index = petugasC.allData.indexWhere((element) => element.id == id);

    try {
      await _provider.productReturn(
        id,
        fineAmount,
        petugasC.allData[index].detailPinjaman,
        _authC.userWithModel.value?.id ?? '',
        _authC.userWithModel.value?.nama ?? '',
        petugasC.allData[index].namaPeminjam,
      );
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
  }

  int countMonetaryFine(DateTime tanggalKembali, DateTime tenggatWaktu) {
    final tanggalKembaliWithDate = DateTime(
      tanggalKembali.year,
      tanggalKembali.month,
      tanggalKembali.day,
    );
    final tenggatWaktuWithDate = DateTime(
      tenggatWaktu.year,
      tenggatWaktu.month,
      tenggatWaktu.day,
    );

    final calculateDaysLate = tanggalKembaliWithDate
        .difference(tenggatWaktuWithDate)
        .inDays;

    if (calculateDaysLate > 0) {
      final dendaPerHari = 10000;
      return calculateDaysLate * dendaPerHari;
    }

    return 0;
  }

  String getTwoLetterFromName(String name) {
    if (name.isEmpty) return '';

    final nameUser = name.length > 2 ? name.substring(0, 2) : name;

    return nameUser;
  }

  void showBottomSheetsForReturnProduct(
    String id,
    DateTime tanggalKembali,
    DateTime tenggatWaktu,
    List<DetailPeminjaman> detail,
    String nama,
    DateTime now,
    int durasiTelat,
    int fine,
  ) {
    Get.bottomSheet(
      isScrollControlled: true,
      enterBottomSheetDuration: Duration(milliseconds: 400),
      exitBottomSheetDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      Container(
        height: 550,
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Detail Pengembalian',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Daftar Alat (Total 1 Unit)',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: detail.map((e) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          e.gambar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.nama,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Qty: ${e.qty}',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 5),
            Divider(color: AppColors.textSecondary, thickness: 0.1),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Peminjam',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        getTwoLetterFromName(nama),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: BoxBorder.all(
                  color: now.isAfter(tenggatWaktu)
                      ? AppColors.error
                      : AppColors.primary,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: now.isAfter(tenggatWaktu)
                          ? AppColors.error.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      now.isAfter(tenggatWaktu) ? Icons.warning : Icons.check,
                      size: 18,
                      color: now.isAfter(tenggatWaktu)
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          now.isAfter(tenggatWaktu)
                              ? 'status: terlambat'.toUpperCase()
                              : 'status: aman'.toUpperCase(),
                          style: TextStyle(
                            color: now.isAfter(tenggatWaktu)
                                ? AppColors.error
                                : AppColors.primary,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Durasi',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              durasiTelat > 0 ? '$durasiTelat hari' : '0 Hari',
                              style: TextStyle(
                                color: now.isAfter(tenggatWaktu)
                                    ? AppColors.error
                                    : AppColors.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Denda',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              ConvertToRupiah.convertToRupiah(fine),
                              style: TextStyle(
                                color: now.isAfter(tenggatWaktu)
                                    ? AppColors.error
                                    : AppColors.primary,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      returnProductWithStatusCompleted(
                        id,
                        tanggalKembali,
                        tenggatWaktu,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: AppColors.surface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: AppColors.surface,
                        ),
                        SizedBox(width: 5),
                        Text('Terima Barang & Selesai'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: AppColors.textSecondary),
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: Text('Batal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
