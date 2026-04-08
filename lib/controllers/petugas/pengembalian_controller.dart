import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/providers/petugas/pengembalian_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class PengembalianController extends GetxController {
  final _provider = Get.find<PengembalianProvider>();
  final petugasC = Get.find<PetugasController>();
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

    try {
      await _provider.productReturn(id, fineAmount);
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
}
