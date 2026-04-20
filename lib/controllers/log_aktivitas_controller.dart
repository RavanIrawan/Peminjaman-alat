import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/models/log_aktivitas_model.dart';
import 'package:peminjaman_alat/providers/log_aktivitas_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class LogAktivitasController extends GetxController {
  final logList = <LogAktivitasModel>[];
  Rx<LogAktivitasModel?> logApproved = Rx<LogAktivitasModel?>(null);
  Rx<LogAktivitasModel?> logUpdate = Rx<LogAktivitasModel?>(null);
  Rx<LogAktivitasModel?> logNewItem = Rx<LogAktivitasModel?>(null);
  Rx<LogAktivitasModel?> logRequest = Rx<LogAktivitasModel?>(null);
  final _provider = Get.find<LogAktivitasProvider>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    isLoading.value = true;
    try {
      final response = await _provider.fetchLog();

      logList.clear();
      logApproved.value = null;
      logUpdate.value = null;
      logNewItem.value = null;
      logRequest.value = null;
      
      for (var log in response.docs) {
        final dataLog = log.data() as Map<String, dynamic>;

        final logModelWithData = LogAktivitasModel(
          aksi: dataLog['aksi'] ?? '',
          createdAt: (dataLog['createdAt'] as Timestamp).toDate(),
          idTransaksi: dataLog['idtransaksi'] ?? '',
          idUser: dataLog['idUser'] ?? '',
          type: dataLog['type'] ?? '',
          nama: dataLog['nama'] ?? '',
        );

        logList.add(logModelWithData);

        if (logModelWithData.type == 'persetujuan') {
          logApproved.value = logModelWithData;
        } else if (logModelWithData.type == 'update') {
          logUpdate.value = logModelWithData;
        } else if (logModelWithData.type == 'add-new-item') {
          logNewItem.value = logModelWithData;
        } else if (logModelWithData.type == 'pengajuan') {
          logRequest.value = logModelWithData;
        }
      }
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat mengambil data',
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
